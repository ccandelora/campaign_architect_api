require 'prawn'
require 'prawn/table'

class CampaignExportJob < ApplicationJob
  queue_as :default

  def perform(campaign_id, format, job_id)
    campaign = Campaign.find(campaign_id)
    background_job = campaign.background_jobs.find_by(job_id: job_id)

    return unless background_job

    begin
      background_job.update!(status: 'processing')

      case format
      when 'pdf'
        pdf_path = generate_pdf(campaign)

        # In a real app, you'd upload this to S3 or similar
        # For now, we'll just store the path
        background_job.update!(
          status: 'completed',
          result: {
            format: 'pdf',
            file_path: pdf_path,
            download_url: "/downloads/#{File.basename(pdf_path)}",
            file_size: File.size(pdf_path)
          }
        )
      end

    rescue => e
      background_job.update!(
        status: 'failed',
        result: { error: e.message }
      )
    end
  end

  private

  def generate_pdf(campaign)
    filename = "campaign_#{campaign.id}_#{Time.current.strftime('%Y%m%d_%H%M%S')}.pdf"
    filepath = Rails.root.join('tmp', filename)

    Prawn::Document.generate(filepath) do |pdf|
      # Header
      pdf.font_size 24
      pdf.text "Campaign Plan: #{campaign.name}", style: :bold, align: :center
      pdf.move_down 10

      pdf.font_size 12
      pdf.text "Brand: #{campaign.brand.capitalize}", align: :center
      pdf.text "Goal: #{campaign.goal}", align: :center
      pdf.text "Created: #{campaign.created_at.strftime('%B %d, %Y')}", align: :center

      pdf.move_down 30

      # Campaign Overview
      pdf.font_size 16
      pdf.text "Campaign Overview", style: :bold
      pdf.move_down 10

      pdf.font_size 10
      overview_data = [
        ["Campaign Name", campaign.name],
        ["Brand", campaign.brand.capitalize],
        ["Primary Goal", campaign.goal],
        ["Status", campaign.status.capitalize],
        ["Created", campaign.created_at.strftime('%B %d, %Y at %I:%M %p')],
        ["Last Updated", campaign.updated_at.strftime('%B %d, %Y at %I:%M %p')]
      ]

      pdf.table(overview_data, width: pdf.bounds.width) do
        cells.padding = 8
        cells.borders = [:top, :bottom]
        cells.border_width = 0.5
        column(0).font_style = :bold
        column(0).width = 120
      end

      pdf.move_down 30

      # UTM Tracking Settings
      if campaign.utm_parameters.present?
        pdf.font_size 16
        pdf.text "UTM Tracking Settings", style: :bold
        pdf.move_down 10

        pdf.font_size 10
        utm_data = [
          ["UTM Source", campaign.utm_parameters['source'] || 'Not set'],
          ["UTM Medium", campaign.utm_parameters['medium'] || 'Not set'],
          ["UTM Campaign", campaign.utm_parameters['campaign'] || 'Not set']
        ]

        pdf.table(utm_data, width: pdf.bounds.width) do
          cells.padding = 8
          cells.borders = [:top, :bottom]
          cells.border_width = 0.5
          column(0).font_style = :bold
          column(0).width = 120
        end

        pdf.move_down 30
      end

      # Campaign Flow
      pdf.font_size 16
      pdf.text "Campaign Flow", style: :bold
      pdf.move_down 10

      nodes = campaign.structure['nodes'] || []
      edges = campaign.structure['edges'] || []

      if nodes.any?
        nodes.each_with_index do |node, index|
          pdf.font_size 14
          pdf.text "#{index + 1}. #{node['data']['name'] || node['type'].capitalize}", style: :bold
          pdf.move_down 5

          pdf.font_size 10

          case node['type']
          when 'email'
            pdf.text "Type: Email"
            pdf.text "Subject: #{node['data']['subject']}" if node['data']['subject'].present?
            pdf.text "Preheader: #{node['data']['preheader']}" if node['data']['preheader'].present?
            if node['data']['body'].present?
              pdf.text "Body:"
              pdf.indent(20) do
                # Strip HTML tags for PDF
                body_text = node['data']['body'].gsub(/<[^>]*>/, '').strip
                pdf.text body_text
              end
            end

          when 'push'
            pdf.text "Type: Push Notification"
            pdf.text "Title: #{node['data']['title']}" if node['data']['title'].present?
            pdf.text "Body: #{node['data']['body']}" if node['data']['body'].present?

          when 'ad'
            pdf.text "Type: Advertisement"
            pdf.text "Platform: #{node['data']['platform']}" if node['data']['platform'].present?
            pdf.text "Headline: #{node['data']['headline']}" if node['data']['headline'].present?
            pdf.text "Body Copy: #{node['data']['body_copy']}" if node['data']['body_copy'].present?
            pdf.text "Creative Notes: #{node['data']['creative_notes']}" if node['data']['creative_notes'].present?

          when 'delay'
            pdf.text "Type: Delay"
            pdf.text "Duration: #{node['data']['duration']} #{node['data']['unit']}"

          when 'conditional_split'
            pdf.text "Type: Conditional Split"
            pdf.text "Condition: #{node['data']['condition']}" if node['data']['condition'].present?

          when 'ga4_event'
            pdf.text "Type: GA4 Event"
            pdf.text "Event Name: #{node['data']['event_name']}" if node['data']['event_name'].present?
            pdf.text "Trigger: #{node['data']['trigger']}" if node['data']['trigger'].present?
            if node['data']['parameters'].present?
              pdf.text "Parameters: #{node['data']['parameters'].to_json}"
            end
          end

          pdf.move_down 15
        end
      else
        pdf.text "No campaign flow defined yet."
      end

      # Performance Data (if available)
      if campaign.predicted_performance.present? || campaign.actual_performance.present?
        pdf.start_new_page

        pdf.font_size 16
        pdf.text "Performance Data", style: :bold
        pdf.move_down 10

        if campaign.predicted_performance.present?
          pdf.font_size 14
          pdf.text "Predicted Performance", style: :bold
          pdf.move_down 5

          pdf.font_size 10
          campaign.predicted_performance.each do |key, value|
            pdf.text "#{key.humanize}: #{value}"
          end
          pdf.move_down 15
        end

        if campaign.actual_performance.present?
          pdf.font_size 14
          pdf.text "Actual Performance", style: :bold
          pdf.move_down 5

          pdf.font_size 10
          campaign.actual_performance.each do |key, value|
            pdf.text "#{key.humanize}: #{value}"
          end
          pdf.move_down 15
        end

        if campaign.predicted_vs_actual.present?
          pdf.font_size 14
          pdf.text "Performance Comparison", style: :bold
          pdf.move_down 5

          pdf.font_size 10
          variance = campaign.predicted_vs_actual[:variance]
          variance.each do |metric, diff|
            status = diff > 0 ? "↑" : "↓"
            pdf.text "#{metric.humanize}: #{status} #{diff.abs.round(2)}%"
          end
        end
      end

      # Footer
      pdf.number_pages "Page <page> of <total>",
                       at: [pdf.bounds.right - 150, 0],
                       width: 150,
                       align: :right,
                       size: 9
    end

    filepath.to_s
  end
end
