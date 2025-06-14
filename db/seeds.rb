# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a sample user for testing
user = User.find_or_create_by(email: 'maria@example.com') do |u|
  u.name = 'Maria Martinez'
  u.provider = 'google_oauth2'
  u.uid = 'test_uid_123'
end

# Also ensure Chris Candelora exists (the actual logged-in user)
chris = User.find_or_create_by(email: 'chris.candelora@gmail.com') do |u|
  u.name = 'Chris Candelora'
  u.provider = 'google'
  u.uid = 'google_oauth2_123456789'
end

puts "Created users: #{User.count}"

# Create Campaign Templates
puts "Creating campaign templates..."

# Everclear Templates
CampaignTemplate.create!([
  {
    name: "The Gentle Nudge",
    brand: "everclear",
    goal: "Reactivate Lapsed Users",
    description: "A simple, 3-part email sequence to gently re-engage dormant users with empathetic messaging.",
    structure: {
      nodes: [
        {
          id: "gentle-email-1",
          type: "email",
          position: { x: 150, y: 50 },
          data: {
            name: "We Miss You Email",
            subject: "Your path to clarity is still here",
            preheader: "We're here when you're ready",
            body: "Hi there,\n\nWe noticed you haven't connected with an advisor in a while. Life gets busy, and sometimes we all need a gentle reminder that support is available when we're ready.\n\nYour journey to clarity doesn't have a timeline. Whether you're facing a new challenge or just need someone to listen, our advisors are here with the same compassion and insight you experienced before.\n\nTake your time. We'll be here.\n\nWith understanding,\nThe Everclear Team"
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 150, y: 200 },
          data: {
            duration: 3,
            unit: "days"
          }
        },
        {
          id: "gentle-email-2",
          type: "email",
          position: { x: 150, y: 350 },
          data: {
            name: "Gentle Check-in",
            subject: "Sometimes the universe sends signs",
            preheader: "Maybe this is yours",
            body: "Hello again,\n\nSometimes the universe has a way of putting exactly what we need in front of us at the right moment. Maybe this email is one of those signs.\n\nIf you've been feeling stuck, uncertain, or just need someone who truly understands, our advisors are ready to help you find your way forward.\n\nNo pressure, no rush. Just genuine support when you're ready to receive it.\n\nTrusting in perfect timing,\nEverclear"
          }
        },
        {
          id: "delay-2",
          type: "delay",
          position: { x: 150, y: 500 },
          data: {
            duration: 5,
            unit: "days"
          }
        },
        {
          id: "gentle-email-3",
          type: "email",
          position: { x: 150, y: 650 },
          data: {
            name: "Final Gentle Outreach",
            subject: "Your advisor is thinking of you",
            preheader: "One last note from us",
            body: "Dear friend,\n\nThis is our final note for now. We want you to know that your previous advisor still thinks about your journey and hopes you're finding the clarity you seek.\n\nIf you ever feel called to reconnect, we'll be here with open hearts and minds. Your growth and peace matter to us.\n\nUntil our paths cross again,\nWith love and light,\nEverclear"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "gentle-email-1", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "gentle-email-2" },
        { id: "edge-3", source: "gentle-email-2", target: "delay-2" },
        { id: "edge-4", source: "delay-2", target: "gentle-email-3" }
      ]
    },
    metadata: {
      channels: ["email"],
      complexity: "beginner",
      setup_time: "10 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "22%",
        click_rate: "3.5%"
      }
    }
  },
  {
    name: "The Multi-Channel Push",
    brand: "everclear",
    goal: "Reactivate Lapsed Users",
    description: "An email sequence combined with a retargeting ad campaign for maximum re-engagement impact.",
    structure: {
      nodes: [
        {
          id: "reactivation-email-1",
          type: "email",
          position: { x: 100, y: 50 },
          data: {
            name: "Comeback Email",
            subject: "We've missed your energy",
            preheader: "Something special is waiting",
            body: "Hi there,\n\nWe've been thinking about you and the journey you started with us. Sometimes life pulls us in different directions, and that's perfectly okay.\n\nWe wanted to reach out because we have something special we think you'll love - and we'd hate for you to miss it.\n\nReady to reconnect?\n\nWarmly,\nEverclear"
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 100, y: 200 },
          data: {
            duration: 2,
            unit: "days"
          }
        },
        {
          id: "retargeting-ad-1",
          type: "ad",
          position: { x: 300, y: 200 },
          data: {
            name: "Retargeting Ad",
            platform: "Facebook",
            headline: "Your advisor is waiting",
            body_copy: "Reconnect with the clarity you've been seeking. Your journey continues here.",
            creative_notes: "Use calming, mystical imagery with soft lighting"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "reactivation-email-1", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "retargeting-ad-1" }
      ]
    },
    metadata: {
      channels: ["email", "ads"],
      complexity: "intermediate",
      setup_time: "25 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "28%",
        click_rate: "5.2%"
      }
    }
  },
  {
    name: "Feature Launch Announcement",
    brand: "everclear",
    goal: "Promote a New Feature/Offer",
    description: "A comprehensive campaign to introduce new features with email and push notifications.",
    structure: {
      nodes: [
        {
          id: "announcement-email",
          type: "email",
          position: { x: 150, y: 50 },
          data: {
            name: "Feature Announcement",
            subject: "Something magical just arrived",
            preheader: "You're going to love this",
            body: "We're thrilled to share something we've been working on just for you.\n\n[New Feature] is here, and it's designed to make your journey to clarity even more meaningful and accessible.\n\nBe among the first to experience this new way of connecting with guidance.\n\nExplore [New Feature] →\n\nWith excitement,\nThe Everclear Team"
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 150, y: 200 },
          data: {
            duration: 1,
            unit: "days"
          }
        },
        {
          id: "push-notification-1",
          type: "push",
          position: { x: 150, y: 350 },
          data: {
            name: "Feature Reminder",
            title: "✨ New Feature Available",
            body: "Discover what's waiting for you in Everclear"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "announcement-email", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "push-notification-1" }
      ]
    },
    metadata: {
      channels: ["email", "push"],
      complexity: "beginner",
      setup_time: "15 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "35%",
        click_rate: "8.2%"
      }
    }
  },
  {
    name: "New User Onboarding",
    brand: "everclear",
    goal: "Acquire New Users",
    description: "A welcoming sequence to guide new users through their first reading experience.",
    structure: {
      nodes: [
        {
          id: "welcome-email",
          type: "email",
          position: { x: 150, y: 50 },
          data: {
            name: "Welcome Email",
            subject: "Welcome to your journey of clarity",
            preheader: "Your first reading awaits",
            body: "Welcome to Everclear,\n\nYou've taken a beautiful first step toward clarity and understanding. We're honored to be part of your journey.\n\nYour first reading is on us - a gift to help you experience the insight and guidance our advisors provide.\n\nClaim Your Free Reading →\n\nWith warm welcome,\nEverclear"
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 150, y: 200 },
          data: {
            duration: 3,
            unit: "days"
          }
        },
        {
          id: "guidance-email",
          type: "email",
          position: { x: 150, y: 350 },
          data: {
            name: "How It Works",
            subject: "Your guide to getting the most from Everclear",
            preheader: "Tips for meaningful connections",
            body: "Hi there,\n\nWe wanted to share some insights on how to make the most of your time with our advisors.\n\nThe best readings happen when you:\n• Come with an open heart\n• Ask specific questions\n• Trust the process\n\nReady to connect?\n\nWith guidance,\nEverclear"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "welcome-email", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "guidance-email" }
      ]
    },
    metadata: {
      channels: ["email"],
      complexity: "beginner",
      setup_time: "12 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "45%",
        click_rate: "12.1%"
      }
    }
  }
])

# Phrendly Templates
CampaignTemplate.create!([
  {
    name: "New User Welcome Series",
    brand: "phrendly",
    goal: "Acquire New Users",
    description: "A fun, engaging welcome sequence with email and push notifications to get new users chatting.",
    structure: {
      nodes: [
        {
          id: "welcome-email",
          type: "email",
          position: { x: 150, y: 50 },
          data: {
            name: "Welcome to Phrendly",
            subject: "Welcome to the fun! 🎉",
            preheader: "Your first drink is on us",
            body: "Hey there!\n\nWelcome to Phrendly - where every conversation is an adventure and every connection could be the start of something amazing.\n\nWe've added some free drinks to your account to get you started. Time to break the ice!\n\nStart Chatting →\n\nCheers,\nThe Phrendly Team"
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 150, y: 200 },
          data: {
            duration: 1,
            unit: "days"
          }
        },
        {
          id: "push-notification-1",
          type: "push",
          position: { x: 150, y: 350 },
          data: {
            name: "First Chat Reminder",
            title: "Someone's waiting to chat! 💬",
            body: "Your free drinks are ready to use"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "welcome-email", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "push-notification-1" }
      ]
    },
    metadata: {
      channels: ["email", "push"],
      complexity: "beginner",
      setup_time: "8 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "52%",
        click_rate: "18.3%"
      }
    }
  },
  {
    name: "Earner Onboarding Flow",
    brand: "phrendly",
    goal: "Onboard New Earners",
    description: "A comprehensive onboarding sequence to help new earners set up their profiles and start earning.",
    structure: {
      nodes: [
        {
          id: "earner-welcome",
          type: "email",
          position: { x: 150, y: 50 },
          data: {
            name: "Earner Welcome",
            subject: "Ready to start earning? Let's do this! 💰",
            preheader: "Your earning journey begins now",
            body: "Congratulations on joining Phrendly as an earner!\n\nYou're about to embark on an exciting journey where your personality and charm can earn you real money.\n\nLet's get your profile set up for success:\n\n✓ Complete your profile (earn more!)\n✓ Add great photos\n✓ Write a compelling bio\n\nStart Earning →\n\nTo your success,\nPhrendly"
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 150, y: 200 },
          data: {
            duration: 2,
            unit: "days"
          }
        },
        {
          id: "tips-email",
          type: "email",
          position: { x: 150, y: 350 },
          data: {
            name: "Earning Tips",
            subject: "Pro tips from our top earners 🌟",
            preheader: "Insider secrets to maximize earnings",
            body: "Want to know what our top earners do differently?\n\nHere are their secrets:\n\n• Respond quickly to messages\n• Be genuine and engaging\n• Use great photos that show your personality\n• Stay active during peak hours\n\nReady to put these tips into action?\n\nHappy earning!\nPhrendly"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "earner-welcome", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "tips-email" }
      ]
    },
    metadata: {
      channels: ["email"],
      complexity: "intermediate",
      setup_time: "15 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "38%",
        click_rate: "9.7%"
      }
    }
  },
  {
    name: "Feature Spotlight Campaign",
    brand: "phrendly",
    goal: "Promote a New Feature/Offer",
    description: "Multi-channel campaign to promote new features with email, push, and ads.",
    structure: {
      nodes: [
        {
          id: "feature-email",
          type: "email",
          position: { x: 100, y: 50 },
          data: {
            name: "New Feature Announcement",
            subject: "Something exciting just dropped! 🚀",
            preheader: "You're going to love this",
            body: "Hey Phrendly fam!\n\nWe've been working on something special just for you, and it's finally here!\n\n[New Feature] is designed to make your Phrendly experience even more fun and engaging.\n\nBe the first to try it out!\n\nCheck It Out →\n\nXOXO,\nPhrendly"
          }
        },
        {
          id: "push-notification-1",
          type: "push",
          position: { x: 300, y: 150 },
          data: {
            name: "Feature Push",
            title: "🎉 New Feature Alert!",
            body: "Check out what's new in Phrendly"
          }
        },
        {
          id: "social-ad",
          type: "ad",
          position: { x: 200, y: 250 },
          data: {
            name: "Social Media Ad",
            platform: "TikTok",
            headline: "The chat app everyone's talking about",
            body_copy: "Discover [New Feature] on Phrendly - where conversations turn into connections.",
            creative_notes: "Use vibrant, fun visuals with young, diverse people chatting"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "feature-email", target: "push-notification-1" },
        { id: "edge-2", source: "feature-email", target: "social-ad" }
      ]
    },
    metadata: {
      channels: ["email", "push", "ads"],
      complexity: "advanced",
      setup_time: "30 minutes",
      recommended: true,
      estimated_performance: {
        open_rate: "41%",
        click_rate: "11.8%"
      }
    }
  }
])

puts "Created #{CampaignTemplate.count} campaign templates"

# Create comprehensive reference campaigns for Chris Candelora
reference_campaign_1 = chris.campaigns.find_or_create_by(
  name: "REFERENCE: Complete Multi-Channel Campaign Template",
  brand: "everclear"
) do |campaign|
  campaign.goal = "Increase Day-7 User Activation Rate"
  campaign.structure = {
    nodes: [
      {
        id: "welcome-everclear",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "Welcome Email",
          subject: "Your path to clarity starts now",
          preheader: "Your first reading is on us",
          body: "Welcome to Everclear, where your journey to clarity begins.\n\nWe know you're here because you're seeking answers, guidance, or simply someone who understands. Our gifted advisors are ready to help you navigate whatever challenges you're facing.\n\nYour first reading is complimentary - a gift to help you experience the insight and support that awaits you.\n\nReady to connect with an advisor who truly gets you?\n\nWith light and wisdom,\nThe Everclear Team"
        }
      },
      {
        id: "delay-2days",
        type: "delay",
        position: { x: 150, y: 200 },
        data: { duration: 2, unit: "days" }
      },
      {
        id: "conditional-opened",
        type: "conditional",
        position: { x: 150, y: 350 },
        data: {
          name: "Opened Welcome Email?",
          condition: "User opened last email"
        }
      },
      {
        id: "followup-opened",
        type: "email",
        position: { x: 50, y: 500 },
        data: {
          name: "Follow-up for Openers",
          subject: "Your advisor is waiting",
          body: "We noticed you opened our welcome email. Your perfect advisor match is ready to connect with you."
        }
      },
      {
        id: "re-engagement",
        type: "email",
        position: { x: 250, y: 500 },
        data: {
          name: "Re-engagement Email",
          subject: "Sometimes the universe sends signs",
          body: "Maybe this email is the sign you've been waiting for. Your clarity journey is just one conversation away."
        }
      },
      {
        id: "push-mobile",
        type: "push",
        position: { x: 150, y: 650 },
        data: {
          name: "Mobile Push Notification",
          title: "Your reading awaits ✨",
          body: "Connect with an advisor who understands your journey"
        }
      },
      {
        id: "retargeting-ad",
        type: "ad",
        position: { x: 350, y: 350 },
        data: {
          name: "Retargeting Ad",
          platform: "Facebook",
          headline: "Find Your Path Forward",
          body_copy: "Connect with trusted psychic advisors who understand your journey. First reading free.",
          creative_notes: "Use mystical, calming imagery with soft purple/blue tones. Show diverse, peaceful faces."
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "welcome-everclear", target: "delay-2days" },
      { id: "edge-2", source: "delay-2days", target: "conditional-opened" },
      { id: "edge-3", source: "conditional-opened", target: "followup-opened" },
      { id: "edge-4", source: "conditional-opened", target: "re-engagement" },
      { id: "edge-5", source: "followup-opened", target: "push-mobile" },
      { id: "edge-6", source: "re-engagement", target: "push-mobile" }
    ]
  }
end

reference_campaign_2 = chris.campaigns.find_or_create_by(
  name: "REFERENCE: Phrendly Engagement Booster",
  brand: "phrendly"
) do |campaign|
  campaign.goal = "Increase User-to-User Interaction Rate"
  campaign.structure = {
    nodes: [
      {
        id: "welcome-phrendly",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "Welcome Email",
          subject: "Hey there, gorgeous! Welcome to Phrendly 💋",
          preheader: "Your first drink is FREE!",
          body: "Hey there, gorgeous!\n\nWelcome to Phrendly - where flirting meets fun and every conversation sparkles! ✨\n\nYou're about to discover the most exciting way to connect with amazing people. Whether you're here to chat, flirt, or just have a blast, you've found your new favorite playground.\n\nYour first drink is FREE! 🍹 Use it to break the ice with someone who catches your eye.\n\nReady to dive in? Here's how to get started:\n1. Complete your profile (the more pics, the more attention!)\n2. Browse and find someone who makes you smile\n3. Send them a drink and start the conversation\n\nThe party starts now! 🎉\n\nXOXO,\nThe Phrendly Team"
        }
      },
      {
        id: "delay-1day",
        type: "delay",
        position: { x: 150, y: 200 },
        data: { duration: 1, unit: "days" }
      },
      {
        id: "engagement-push",
        type: "push",
        position: { x: 150, y: 350 },
        data: {
          name: "Engagement Push",
          title: "Someone's checking you out! 👀",
          body: "Don't keep them waiting - say hello!"
        }
      },
      {
        id: "delay-3days",
        type: "delay",
        position: { x: 150, y: 500 },
        data: { duration: 3, unit: "days" }
      },
      {
        id: "tips-email",
        type: "email",
        position: { x: 150, y: 650 },
        data: {
          name: "Flirting Tips Email",
          subject: "The secret to irresistible conversations 😘",
          body: "Want to know the secret to conversations that keep them coming back for more?\n\nIt's all about the art of playful banter! Here are our top 3 tips:\n\n1. Start with a genuine compliment\n2. Ask questions that spark curiosity\n3. Keep it light and fun - save the deep stuff for later\n\nReady to put these tips to work? Jump back in and watch the magic happen! ✨"
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "welcome-phrendly", target: "delay-1day" },
      { id: "edge-2", source: "delay-1day", target: "engagement-push" },
      { id: "edge-3", source: "engagement-push", target: "delay-3days" },
      { id: "edge-4", source: "delay-3days", target: "tips-email" }
    ]
  }
end

# Create additional example campaigns for variety
example_campaign_1 = chris.campaigns.find_or_create_by(
  name: "Q4 Holiday Special - Everclear",
  brand: "everclear"
) do |campaign|
  campaign.goal = "Promote a New Feature/Offer"
  campaign.status = :approved
  campaign.structure = {
    nodes: [
      {
        id: "holiday-announcement",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "Holiday Special Announcement",
          subject: "A gift of clarity this holiday season ✨",
          preheader: "Special holiday readings now available",
          body: "Dear friend,\n\nThe holidays can be a time of joy, but also reflection and sometimes uncertainty about the year ahead.\n\nThis season, we're offering something special: extended holiday readings with our most gifted advisors, designed to help you find clarity and peace as you transition into the new year.\n\n🎁 Holiday Special: 50% off your first extended reading\n🎁 Valid through December 31st\n🎁 Perfect for reflecting on the year and setting intentions\n\nBook Your Holiday Reading →\n\nWith seasonal blessings,\nEverclear"
        }
      },
      {
        id: "delay-3days",
        type: "delay",
        position: { x: 150, y: 200 },
        data: { duration: 3, unit: "days" }
      },
      {
        id: "reminder-email",
        type: "email",
        position: { x: 150, y: 350 },
        data: {
          name: "Holiday Special Reminder",
          subject: "Your holiday clarity session awaits",
          preheader: "Don't miss this special opportunity",
          body: "Hi there,\n\nJust a gentle reminder that our holiday special readings are still available.\n\nMany of our clients find this time of year perfect for:\n• Reflecting on the year's journey\n• Gaining clarity on relationships\n• Setting intentions for the new year\n• Finding peace during busy times\n\nYour 50% discount is waiting for you.\n\nClaim Your Reading →\n\nWith warm wishes,\nEverclear"
        }
      },
      {
        id: "social-media-ad",
        type: "ad",
        position: { x: 350, y: 200 },
        data: {
          name: "Holiday Facebook Ad",
          platform: "Facebook",
          headline: "Find clarity this holiday season",
          body_copy: "Special holiday readings with gifted psychic advisors. 50% off your first session. Book now through December 31st.",
          creative_notes: "Use warm, festive imagery with soft lighting. Include holiday elements like candles, crystals, or winter scenes."
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "holiday-announcement", target: "delay-3days" },
      { id: "edge-2", source: "delay-3days", target: "reminder-email" },
      { id: "edge-3", source: "holiday-announcement", target: "social-media-ad" }
    ]
  }
  campaign.predicted_performance = {
    "open_rate" => 28.5,
    "click_rate" => 6.2,
    "conversion_rate" => 2.1
  }
end

example_campaign_2 = chris.campaigns.find_or_create_by(
  name: "Lapsed User Winback - Phrendly",
  brand: "phrendly"
) do |campaign|
  campaign.goal = "Reactivate Lapsed Users"
  campaign.status = :live
  campaign.structure = {
    nodes: [
      {
        id: "winback-email-1",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "We Miss You Email",
          subject: "The party's not the same without you! 💔",
          preheader: "Come back and see what you've been missing",
          body: "Hey gorgeous,\n\nWe noticed you haven't been around Phrendly lately, and honestly? We miss you!\n\nThe conversations aren't quite as sparkly without you, and we keep wondering what amazing connections you might be missing out on.\n\nTo welcome you back, we've added some FREE drinks to your account - no strings attached. Just our way of saying we'd love to see you again.\n\n🍹 5 FREE drinks waiting for you\n🍹 New people have joined since you left\n🍹 Your profile is still getting views!\n\nCome Back and Chat →\n\nMissing you,\nPhrendly"
        }
      },
      {
        id: "delay-5days",
        type: "delay",
        position: { x: 150, y: 200 },
        data: { duration: 5, unit: "days" }
      },
      {
        id: "conditional-opened",
        type: "conditional",
        position: { x: 150, y: 350 },
        data: {
          name: "Opened Winback Email?",
          condition: "User opened last email"
        }
      },
      {
        id: "push-notification",
        type: "push",
        position: { x: 50, y: 500 },
        data: {
          name: "Winback Push",
          title: "Your free drinks are waiting! 🍹",
          body: "5 free drinks just for you - no expiration"
        }
      },
      {
        id: "final-email",
        type: "email",
        position: { x: 250, y: 500 },
        data: {
          name: "Final Winback Attempt",
          subject: "Last call for your free drinks 🍹",
          preheader: "We won't bug you after this, promise",
          body: "Hey there,\n\nThis is our last message (we promise we won't be that clingy ex! 😅).\n\nYour free drinks are still waiting, and we genuinely hope you'll give us another chance. But if not, we totally understand.\n\nJust know that if you ever want to come back and chat, flirt, or just have some fun, we'll be here with open arms (and free drinks).\n\nNo hard feelings either way! ❤️\n\nOne Last Chance →\n\nWith love (but not too much pressure),\nPhrendly"
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "winback-email-1", target: "delay-5days" },
      { id: "edge-2", source: "delay-5days", target: "conditional-opened" },
      { id: "edge-3", source: "conditional-opened", target: "push-notification" },
      { id: "edge-4", source: "conditional-opened", target: "final-email" }
    ]
  }
  campaign.predicted_performance = {
    "open_rate" => 22.1,
    "click_rate" => 4.8,
    "reactivation_rate" => 8.3
  }
end

example_campaign_3 = chris.campaigns.find_or_create_by(
  name: "New Advisor Spotlight - Everclear",
  brand: "everclear"
) do |campaign|
  campaign.goal = "Engage Existing Users"
  campaign.status = :draft
  campaign.structure = {
    nodes: [
      {
        id: "advisor-spotlight",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "Meet Our New Advisor",
          subject: "Meet Luna - our newest gifted advisor ✨",
          preheader: "Specializing in love and relationship guidance",
          body: "Dear valued client,\n\nWe're excited to introduce you to Luna, our newest advisor who has joined the Everclear family.\n\nLuna brings over 15 years of experience in:\n• Love and relationship guidance\n• Career transitions and life purpose\n• Spiritual awakening and personal growth\n• Tarot and crystal healing\n\nWhat makes Luna special? Her clients consistently tell us she has an incredible gift for seeing the heart of any situation and providing guidance that feels both deeply intuitive and practically actionable.\n\n\"Luna helped me see my relationship patterns in a completely new light. Her insights were spot-on and her guidance was exactly what I needed to hear.\" - Sarah M.\n\nBook a Reading with Luna →\n\nWith light,\nEverclear"
        }
      },
      {
        id: "delay-2days",
        type: "delay",
        position: { x: 150, y: 200 },
        data: { duration: 2, unit: "days" }
      },
      {
        id: "social-proof-email",
        type: "email",
        position: { x: 150, y: 350 },
        data: {
          name: "Luna's Client Reviews",
          subject: "See what clients are saying about Luna",
          preheader: "Real reviews from real readings",
          body: "Hi there,\n\nSince we introduced you to Luna a few days ago, she's already been connecting with clients and the feedback has been incredible:\n\n⭐⭐⭐⭐⭐ \"Luna's reading was exactly what I needed. She saw things I hadn't even told her about my situation.\" - Jennifer K.\n\n⭐⭐⭐⭐⭐ \"I was skeptical at first, but Luna's insights about my career path were so accurate it gave me chills.\" - Michael R.\n\n⭐⭐⭐⭐⭐ \"Luna helped me understand my relationship in a way that finally made sense. I feel so much clearer now.\" - Amanda T.\n\nLuna has limited availability, but she's accepting new clients this week.\n\nConnect with Luna →\n\nBlessings,\nEverclear"
        }
      },
      {
        id: "instagram-ad",
        type: "ad",
        position: { x: 350, y: 200 },
        data: {
          name: "Luna Instagram Ad",
          platform: "Instagram",
          headline: "Meet Luna, our newest gifted advisor",
          body_copy: "Specializing in love, relationships, and life purpose. Book your reading with Luna today.",
          creative_notes: "Use Luna's professional photo with mystical background. Include client testimonial quotes as overlay text."
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "advisor-spotlight", target: "delay-2days" },
      { id: "edge-2", source: "delay-2days", target: "social-proof-email" },
      { id: "edge-3", source: "advisor-spotlight", target: "instagram-ad" }
    ]
  }
end

example_campaign_4 = chris.campaigns.find_or_create_by(
  name: "Weekend Boost Campaign - Phrendly",
  brand: "phrendly"
) do |campaign|
  campaign.goal = "Engage Existing Users"
  campaign.status = :completed
  campaign.structure = {
    nodes: [
      {
        id: "friday-kickoff",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "Friday Night Kickoff",
          subject: "Friday night = Phrendly night! 🎉",
          preheader: "The weekend starts now",
          body: "Hey party people!\n\nIt's Friday night and you know what that means... time to turn up the charm on Phrendly! 🔥\n\nWeekends are when the magic happens:\n• More people are online and ready to chat\n• Everyone's in a fun, flirty mood\n• Perfect time for those longer conversations\n• Weekend vibes = better connections\n\nWe've added 3 FREE drinks to your account to get your weekend started right!\n\nStart Your Weekend Right →\n\nLet's make this weekend unforgettable!\nPhrendly"
        }
      },
      {
        id: "saturday-push",
        type: "push",
        position: { x: 150, y: 200 },
        data: {
          name: "Saturday Activity Push",
          title: "Saturday night energy! ⚡",
          body: "The chat rooms are buzzing - join the fun!"
        }
      },
      {
        id: "sunday-wind-down",
        type: "email",
        position: { x: 150, y: 350 },
        data: {
          name: "Sunday Wind Down",
          subject: "Sunday funday conversations 😎",
          preheader: "Perfect day for deeper chats",
          body: "Hey beautiful,\n\nSunday vibes are different, aren't they? It's the perfect day for those deeper, more meaningful conversations.\n\nWhile everyone else is getting the Sunday scaries, you could be having amazing chats with people who really get you.\n\nSunday is perfect for:\n• Longer, more intimate conversations\n• Getting to know someone on a deeper level\n• Planning fun things for the week ahead\n• Just enjoying good company\n\nYour weekend drinks are still available if you haven't used them yet!\n\nMake Sunday Special →\n\nEnjoy your Sunday,\nPhrendly"
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "friday-kickoff", target: "saturday-push" },
      { id: "edge-2", source: "saturday-push", target: "sunday-wind-down" }
    ]
  }
  campaign.actual_performance = {
    "open_rate" => 31.2,
    "click_rate" => 8.7,
    "engagement_lift" => 15.4
  }
  campaign.predicted_performance = {
    "open_rate" => 28.0,
    "click_rate" => 7.2,
    "engagement_lift" => 12.0
  }
end

example_campaign_5 = chris.campaigns.find_or_create_by(
  name: "A/B Test: Subject Line Experiment",
  brand: "everclear"
) do |campaign|
  campaign.goal = "Acquire New Users"
  campaign.status = :completed
  campaign.structure = {
    nodes: [
      {
        id: "ab-test-email",
        type: "email",
        position: { x: 150, y: 50 },
        data: {
          name: "A/B Test Welcome Email",
          subject: "Your journey to clarity begins now",
          preheader: "First reading is complimentary",
          body: "Welcome to Everclear,\n\nYou've taken the first step toward finding the clarity and guidance you've been seeking.\n\nOur gifted advisors are here to help you navigate life's challenges with wisdom, compassion, and insight.\n\nYour first reading is complimentary - our gift to help you experience the transformative power of a genuine psychic connection.\n\nClaim Your Free Reading →\n\nWith light and wisdom,\nEverclear",
          ab_test: {
            variant_a: {
              subject: "Your journey to clarity begins now",
              hypothesis: "Direct, clear messaging will perform better"
            },
            variant_b: {
              subject: "The answers you seek are waiting ✨",
              hypothesis: "Mystical, emotional messaging will have higher open rates"
            }
          }
        }
      },
      {
        id: "delay-1day",
        type: "delay",
        position: { x: 150, y: 200 },
        data: { duration: 1, unit: "days" }
      },
      {
        id: "followup-email",
        type: "email",
        position: { x: 150, y: 350 },
        data: {
          name: "Follow-up Email",
          subject: "Your advisor is ready when you are",
          preheader: "No pressure, just support",
          body: "Hi there,\n\nWe wanted to follow up on your complimentary reading offer.\n\nThere's no pressure - we know that connecting with an advisor is a personal decision that should feel right for you.\n\nWhen you're ready, we're here.\n\nYour Free Reading →\n\nWith patience and understanding,\nEverclear"
        }
      }
    ],
    edges: [
      { id: "edge-1", source: "ab-test-email", target: "delay-1day" },
      { id: "edge-2", source: "delay-1day", target: "followup-email" }
    ]
  }
  campaign.actual_performance = {
    "variant_a_open_rate" => 24.3,
    "variant_b_open_rate" => 31.7,
    "variant_a_click_rate" => 5.1,
    "variant_b_click_rate" => 6.8,
    "winner" => "variant_b"
  }
  campaign.predicted_performance = {
    "variant_a_open_rate" => 26.0,
    "variant_b_open_rate" => 29.0,
    "variant_a_click_rate" => 5.5,
    "variant_b_click_rate" => 6.2
  }
end

puts "Created campaign templates: #{CampaignTemplate.count}"
puts "Created campaigns: #{Campaign.count}"
puts "✅ Database seeded successfully!"
