# Advanced Marketing Templates based on 2024/2025 Best Practices
# Run with: rails runner db/seeds_advanced_templates.rb

puts "Creating advanced marketing templates..."

# Facebook/Instagram Marketing Templates
CampaignTemplate.create!([
  {
    name: "Facebook Engagement Maximizer",
    brand: "everclear",
    goal: "Engage Existing Users",
    description: "Multi-format Facebook campaign optimized for 2024 algorithm changes with video, carousel, and story ads.",
    structure: {
      nodes: [
        {
          id: "facebook-video-ad",
          type: "social",
          position: { x: 100, y: 50 },
          data: {
            name: "Facebook Video Ad",
            socialData: {
              platform: "facebook",
              content: "🔮 Your clarity journey continues...\n\nReady for your next breakthrough? Our advisors are here to guide you through life's biggest questions.\n\n✨ Book your reading today",
              hashtags: "#clarity #guidance #psychic #everclear",
              creativeNotes: "15-second vertical video showing peaceful, mystical imagery with soft transitions. Include captions for sound-off viewing.",
              targetAudience: "Lookalike audience based on high-LTV customers, ages 25-45",
              callToAction: "Book Reading",
              adObjective: "conversions"
            },
            utmTracking: true
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 100, y: 200 },
          data: {
            duration: 3,
            unit: "days"
          }
        },
        {
          id: "facebook-carousel-ad",
          type: "social",
          position: { x: 100, y: 350 },
          data: {
            name: "Facebook Carousel Retargeting",
            socialData: {
              platform: "facebook",
              content: "Still seeking answers? 🌟\n\nSwipe to see what our advisors can help you with:\n→ Love & Relationships\n→ Career Guidance\n→ Life Purpose\n→ Spiritual Growth",
              hashtags: "#psychicreading #guidance #clarity",
              creativeNotes: "4-card carousel: each card shows different reading type with beautiful, calming imagery",
              targetAudience: "Website visitors who didn't convert",
              callToAction: "Learn More",
              adObjective: "traffic"
            },
            utmTracking: true
          }
        },
        {
          id: "ga4-conversion",
          type: "ga4_event",
          position: { x: 300, y: 200 },
          data: {
            name: "Track Facebook Conversions",
            ga4Event: {
              eventName: "facebook_ad_conversion",
              trigger: "user_books_reading",
              parameters: {
                campaign_source: "facebook",
                campaign_medium: "social",
                campaign_name: "engagement_maximizer",
                value: "25.00",
                currency: "USD"
              }
            }
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "facebook-video-ad", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "facebook-carousel-ad" },
        { id: "edge-3", source: "facebook-video-ad", target: "ga4-conversion" }
      ]
    },
    metadata: {
      channels: ["social", "analytics"],
      complexity: "advanced",
      setup_time: "45 minutes",
      recommended: true,
      estimated_performance: {
        engagement_rate: "4.2%",
        click_rate: "2.8%",
        conversion_rate: "3.1%"
      },
      best_practices: [
        "Use vertical video format (9:16) for mobile optimization",
        "Include captions for 85% of users who watch without sound",
        "Test multiple creative variations",
        "Target lookalike audiences for better performance"
      ]
    }
  },
  {
    name: "Instagram Stories Domination",
    brand: "phrendly",
    goal: "Acquire New Users",
    description: "Instagram Stories campaign with interactive elements, polls, and swipe-up features for maximum engagement.",
    structure: {
      nodes: [
        {
          id: "instagram-story-1",
          type: "social",
          position: { x: 150, y: 50 },
          data: {
            name: "Instagram Story - Poll",
            socialData: {
              platform: "instagram",
              content: "💭 What's your ideal Friday night?\n\nA) Cozy chat with someone special\nB) Wild night out with friends\n\nVote below! 👇",
              hashtags: "#phrendly #chat #fridayvibes",
              creativeNotes: "Bright, fun background with poll sticker. Use brand colors and playful fonts.",
              targetAudience: "Ages 18-35, interested in dating and social apps",
              callToAction: "Swipe Up",
              storyDuration: 24
            },
            utmTracking: true
          }
        },
        {
          id: "instagram-story-2",
          type: "social",
          position: { x: 150, y: 200 },
          data: {
            name: "Instagram Story - Testimonial",
            socialData: {
              platform: "instagram",
              content: "\"I've made amazing friends on Phrendly! The conversations are so genuine and fun.\" - Sarah, 26\n\n✨ Join thousands finding real connections",
              hashtags: "#testimonial #realconnections #phrendly",
              creativeNotes: "User-generated content style with authentic testimonial overlay",
              targetAudience: "Lookalike audience based on active users",
              callToAction: "Sign Up",
              storyDuration: 24
            },
            utmTracking: true
          }
        },
        {
          id: "instagram-reel",
          type: "social",
          position: { x: 150, y: 350 },
          data: {
            name: "Instagram Reel - Trending",
            socialData: {
              platform: "instagram",
              content: "POV: You just joined Phrendly and already have 5 people wanting to chat 💬✨\n\n#PhrendlyLife #NewUserExperience",
              hashtags: "#phrendly #pov #trending #newuser #chat",
              creativeNotes: "Trending audio with quick cuts showing app interface and chat notifications",
              targetAudience: "Gen Z and Millennial users interested in social apps",
              callToAction: "Visit Profile",
              videoScript: "Quick montage showing: app download → profile setup → instant matches → fun conversations"
            },
            utmTracking: true
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "instagram-story-1", target: "instagram-story-2" },
        { id: "edge-2", source: "instagram-story-2", target: "instagram-reel" }
      ]
    },
    metadata: {
      channels: ["social"],
      complexity: "intermediate",
      setup_time: "30 minutes",
      recommended: true,
      estimated_performance: {
        story_completion_rate: "78%",
        swipe_up_rate: "5.4%",
        reel_engagement_rate: "8.2%"
      },
      best_practices: [
        "Use interactive stickers (polls, questions, sliders)",
        "Post during peak hours (7-9 PM)",
        "Include trending hashtags and sounds",
        "Keep text minimal and visually appealing"
      ]
    }
  },
  {
    name: "TikTok Viral Strategy",
    brand: "phrendly",
    goal: "Acquire New Users",
    description: "TikTok campaign leveraging trending sounds, challenges, and Gen Z communication style for viral potential.",
    structure: {
      nodes: [
        {
          id: "tiktok-trend-1",
          type: "social",
          position: { x: 200, y: 50 },
          data: {
            name: "TikTok Trend Video",
            socialData: {
              platform: "tiktok",
              content: "When you're on Phrendly and someone actually wants to have deep conversations at 2 AM 🥺✨\n\n#PhrendlyMoments #LateNightChats",
              hashtags: "#phrendly #latenight #deepconversations #relatable #fyp #viral",
              creativeNotes: "Use trending 'emotional' sound with relatable scenario. Show genuine reactions.",
              targetAudience: "Ages 16-28, interested in social apps and dating",
              callToAction: "Visit Profile",
              videoScript: "Scene 1: Person looking bored on other apps. Scene 2: Opens Phrendly. Scene 3: Surprised/happy reaction to meaningful conversation",
              soundTrack: "Current trending emotional/relatable sound"
            },
            utmTracking: true
          }
        },
        {
          id: "tiktok-trend-2",
          type: "social",
          position: { x: 200, y: 200 },
          data: {
            name: "TikTok Challenge Response",
            socialData: {
              platform: "tiktok",
              content: "Rating dating apps as a Gen Z:\n\n❌ Ghosting central\n❌ Superficial swipes\n✅ Phrendly - actual conversations\n\n#DatingAppReview #GenZ",
              hashtags: "#datingapps #review #genz #phrendly #honest #fyp",
              creativeNotes: "Quick cuts with text overlays, use trending 'rating' format",
              targetAudience: "Gen Z users frustrated with traditional dating apps",
              callToAction: "Learn More",
              videoScript: "Split screen showing bad experiences vs Phrendly positive experience"
            },
            utmTracking: true
          }
        },
        {
          id: "email-follow-up",
          type: "email",
          position: { x: 200, y: 350 },
          data: {
            name: "TikTok Visitor Follow-up",
            subject: "Saw you came from TikTok! 👀",
            preheader: "Welcome to the real conversation revolution",
            body: "Hey TikTok fam! 👋\n\nWe saw you checked us out from our viral video (thanks for that, btw). Ready to experience what real conversations feel like?\n\nYour first drink is on us - because good vibes deserve good starts.\n\nLet's chat! 💬\n\nThe Phrendly Team\n\nP.S. - Follow us @phrendlyapp for more behind-the-scenes content!"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "tiktok-trend-1", target: "tiktok-trend-2" },
        { id: "edge-2", source: "tiktok-trend-2", target: "email-follow-up" }
      ]
    },
    metadata: {
      channels: ["social", "email"],
      complexity: "advanced",
      setup_time: "60 minutes",
      recommended: true,
      estimated_performance: {
        video_completion_rate: "65%",
        engagement_rate: "12.5%",
        click_rate: "4.8%"
      },
      best_practices: [
        "Use trending sounds within 24-48 hours of peak popularity",
        "Keep videos under 30 seconds for maximum retention",
        "Include captions for accessibility",
        "Post during peak TikTok hours (6-10 PM, 7-9 AM)",
        "Engage with comments quickly to boost algorithm performance"
      ]
    }
  },
  {
    name: "Twitter/X Engagement Strategy",
    brand: "everclear",
    goal: "Engage Existing Users",
    description: "Twitter/X campaign with threads, polls, and real-time engagement for thought leadership in spiritual guidance.",
    structure: {
      nodes: [
        {
          id: "twitter-thread",
          type: "social",
          position: { x: 150, y: 50 },
          data: {
            name: "Twitter Thread - Wisdom",
            socialData: {
              platform: "twitter",
              content: "🧵 5 signs the universe is trying to tell you something:\n\n1/ You keep seeing the same numbers everywhere\n2/ Unexpected opportunities keep appearing\n3/ You feel drawn to new experiences\n4/ Old patterns suddenly feel uncomfortable\n5/ You're reading this thread right now ✨\n\nWhat signs have you noticed lately? 👇",
              hashtags: "#spirituality #signs #universe #guidance #thread",
              creativeNotes: "Thread format with engaging hook and call for responses",
              targetAudience: "Spiritually curious individuals, existing followers",
              callToAction: "Reply",
              threadCount: 6
            },
            utmTracking: true
          }
        },
        {
          id: "twitter-poll",
          type: "social",
          position: { x: 150, y: 200 },
          data: {
            name: "Twitter Poll - Engagement",
            socialData: {
              platform: "twitter",
              content: "Quick question for our community 🔮\n\nWhat's your biggest challenge right now?\n\n🤔 Making a big decision\n💕 Love & relationships\n💼 Career direction\n🌟 Finding life purpose\n\nVote below and share your story! Our advisors are here to help ✨",
              hashtags: "#poll #guidance #community #everclear",
              creativeNotes: "Engaging poll with emoji options and community focus",
              targetAudience: "Engaged followers and spiritual community",
              callToAction: "Vote"
            },
            utmTracking: true
          }
        },
        {
          id: "twitter-live-tweet",
          type: "social",
          position: { x: 150, y: 350 },
          data: {
            name: "Live Tweet Session",
            socialData: {
              platform: "twitter",
              content: "🔴 LIVE: Our top advisor Sarah is answering your questions for the next hour!\n\nDrop your questions below with #AskSarah and she'll respond with mini-readings and guidance.\n\nThis is your chance for free insights! ⬇️",
              hashtags: "#AskSarah #live #freereadings #guidance #everclear",
              creativeNotes: "Real-time engagement session with live responses",
              targetAudience: "Active community members and new followers",
              callToAction: "Reply"
            },
            utmTracking: true
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "twitter-thread", target: "twitter-poll" },
        { id: "edge-2", source: "twitter-poll", target: "twitter-live-tweet" }
      ]
    },
    metadata: {
      channels: ["social"],
      complexity: "intermediate",
      setup_time: "40 minutes",
      recommended: true,
      estimated_performance: {
        thread_engagement_rate: "6.8%",
        poll_participation_rate: "15.2%",
        live_session_reach: "2500+"
      },
      best_practices: [
        "Tweet during peak hours (9 AM, 12 PM, 5 PM EST)",
        "Use threads for storytelling and education",
        "Engage with replies within 1-2 hours",
        "Include relevant trending hashtags",
        "Pin important tweets for 24-48 hours"
      ]
    }
  },
  {
    name: "Cross-Platform Retargeting Funnel",
    brand: "everclear",
    goal: "Reactivate Lapsed Users",
    description: "Advanced multi-platform retargeting campaign with Facebook, Instagram, Google, and email touchpoints.",
    structure: {
      nodes: [
        {
          id: "facebook-retargeting",
          type: "social",
          position: { x: 100, y: 50 },
          data: {
            name: "Facebook Retargeting Ad",
            socialData: {
              platform: "facebook",
              content: "We miss you at Everclear 💙\n\nYour journey to clarity doesn't have to pause. Our advisors are still here, ready to help you navigate whatever life has brought your way.\n\nCome back to the guidance you trust.",
              hashtags: "#comeback #guidance #everclear #clarity",
              creativeNotes: "Warm, welcoming imagery with soft colors. Show advisor-client connection.",
              targetAudience: "Users who haven't logged in for 30+ days",
              callToAction: "Book Reading",
              adObjective: "conversions"
            },
            utmTracking: true
          }
        },
        {
          id: "delay-1",
          type: "delay",
          position: { x: 100, y: 200 },
          data: {
            duration: 3,
            unit: "days"
          }
        },
        {
          id: "google-search-ad",
          type: "ad",
          position: { x: 300, y: 200 },
          data: {
            name: "Google Search Retargeting",
            platform: "Google",
            headline: "Your Trusted Psychic Advisors | Everclear",
            body_copy: "Reconnect with the clarity you've been missing. Book a reading with advisors who understand your journey. First session 50% off for returning clients.",
            creative_notes: "Target users searching for 'psychic reading', 'spiritual guidance', 'life advice'"
          }
        },
        {
          id: "email-winback",
          type: "email",
          position: { x: 100, y: 350 },
          data: {
            name: "Winback Email",
            subject: "Your advisor remembers you 💜",
            preheader: "Special offer just for you",
            body: "Hi there,\n\nIt's been a while since we've connected, and we wanted you to know that your previous advisor still thinks about your journey.\n\nLife has a way of bringing us full circle, and maybe this is your moment to reconnect with the guidance that once brought you clarity.\n\nAs a welcome back gift, we're offering you 50% off your next reading.\n\nWhenever you're ready, we're here.\n\nWith love and light,\nEverclear"
          }
        },
        {
          id: "push-notification",
          type: "push",
          position: { x: 100, y: 500 },
          data: {
            name: "Final Reminder",
            title: "✨ Your 50% off expires soon",
            body: "Don't miss your chance to reconnect with clarity"
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "facebook-retargeting", target: "delay-1" },
        { id: "edge-2", source: "delay-1", target: "google-search-ad" },
        { id: "edge-3", source: "delay-1", target: "email-winback" },
        { id: "edge-4", source: "email-winback", target: "push-notification" }
      ]
    },
    metadata: {
      channels: ["social", "ads", "email", "push"],
      complexity: "expert",
      setup_time: "90 minutes",
      recommended: true,
      estimated_performance: {
        overall_conversion_rate: "8.5%",
        cost_per_acquisition: "$18.50",
        return_on_ad_spend: "4.2x"
      },
      best_practices: [
        "Segment audiences by recency of last activity",
        "Use progressive incentives (start small, increase over time)",
        "Maintain consistent messaging across all channels",
        "Set frequency caps to avoid ad fatigue",
        "Track cross-device conversions with GA4"
      ]
    }
  },
  {
    name: "GA4 Enhanced E-commerce Tracking",
    brand: "phrendly",
    goal: "Promote a New Feature/Offer",
    description: "Comprehensive GA4 implementation for tracking user journey from awareness to purchase with enhanced e-commerce events.",
    structure: {
      nodes: [
        {
          id: "ga4-page-view",
          type: "ga4_event",
          position: { x: 150, y: 50 },
          data: {
            name: "Enhanced Page View",
            ga4Event: {
              eventName: "page_view",
              trigger: "user_visits_landing_page",
              parameters: {
                page_title: "New Feature Landing Page",
                page_location: "/new-feature",
                campaign_source: "email",
                campaign_medium: "newsletter",
                content_group1: "feature_promotion"
              }
            }
          }
        },
        {
          id: "ga4-engagement",
          type: "ga4_event",
          position: { x: 150, y: 200 },
          data: {
            name: "Feature Interest",
            ga4Event: {
              eventName: "feature_interest",
              trigger: "user_scrolls_50_percent",
              parameters: {
                engagement_time_msec: "30000",
                feature_name: "video_chat",
                user_segment: "existing_user"
              }
            }
          }
        },
        {
          id: "ga4-add-to-cart",
          type: "ga4_event",
          position: { x: 150, y: 350 },
          data: {
            name: "Add Payment Method",
            ga4Event: {
              eventName: "add_payment_info",
              trigger: "user_adds_payment_method",
              parameters: {
                currency: "USD",
                value: "9.99",
                payment_type: "credit_card",
                item_id: "video_chat_upgrade"
              }
            }
          }
        },
        {
          id: "ga4-purchase",
          type: "ga4_event",
          position: { x: 150, y: 500 },
          data: {
            name: "Feature Purchase",
            ga4Event: {
              eventName: "purchase",
              trigger: "user_completes_purchase",
              parameters: {
                transaction_id: "auto_generated",
                value: "9.99",
                currency: "USD",
                items: [
                  {
                    item_id: "video_chat_upgrade",
                    item_name: "Video Chat Feature",
                    category: "premium_features",
                    quantity: 1,
                    price: 9.99
                  }
                ]
              }
            }
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "ga4-page-view", target: "ga4-engagement" },
        { id: "edge-2", source: "ga4-engagement", target: "ga4-add-to-cart" },
        { id: "edge-3", source: "ga4-add-to-cart", target: "ga4-purchase" }
      ]
    },
    metadata: {
      channels: ["analytics"],
      complexity: "expert",
      setup_time: "120 minutes",
      recommended: true,
      estimated_performance: {
        conversion_tracking_accuracy: "95%+",
        attribution_improvement: "40%",
        data_quality_score: "9.2/10"
      },
      best_practices: [
        "Implement enhanced e-commerce tracking",
        "Use custom dimensions for user segmentation",
        "Set up conversion goals and audiences",
        "Enable Google Ads linking for better attribution",
        "Configure data retention settings appropriately"
      ]
    }
  },
  {
    name: "A/B Testing Mastery Campaign",
    brand: "everclear",
    goal: "Engage Existing Users",
    description: "Comprehensive A/B testing campaign for email subject lines, ad creative, and landing page optimization.",
    structure: {
      nodes: [
        {
          id: "ab-test-email",
          type: "ab_test",
          position: { x: 150, y: 50 },
          data: {
            name: "Subject Line A/B Test",
            hypothesis: "Personalized subject lines will increase open rates by 15%",
            split_percentage: 50,
            variants: {
              A: {
                subject: "Your reading is ready",
                body: "Hi there,\n\nYour personalized reading is ready and waiting for you.\n\nDiscover what the universe has in store for you today.\n\nView Your Reading →"
              },
              B: {
                subject: "Sarah, your cosmic guidance awaits ✨",
                body: "Hi Sarah,\n\nThe stars have aligned, and your personalized reading is ready.\n\nYour advisor has insights specifically for you about what's coming next in your journey.\n\nView Your Personal Reading →"
              }
            }
          }
        },
        {
          id: "ab-test-ad",
          type: "ab_test",
          position: { x: 150, y: 250 },
          data: {
            name: "Ad Creative A/B Test",
            hypothesis: "Video ads will outperform static image ads by 25%",
            split_percentage: 50,
            variants: {
              A: {
                creative_type: "static_image",
                headline: "Find Your Path Forward",
                body: "Connect with experienced advisors who understand your journey. Get clarity on love, career, and life purpose.",
                image_notes: "Peaceful meditation scene with soft lighting"
              },
              B: {
                creative_type: "video",
                headline: "Your Journey to Clarity Starts Here",
                body: "See how our advisors help people just like you find answers and peace of mind.",
                video_notes: "15-second testimonial montage with calming background music"
              }
            }
          }
        },
        {
          id: "ga4-ab-tracking",
          type: "ga4_event",
          position: { x: 350, y: 150 },
          data: {
            name: "A/B Test Tracking",
            ga4Event: {
              eventName: "ab_test_exposure",
              trigger: "user_sees_variant",
              parameters: {
                test_name: "email_subject_personalization",
                variant_id: "A_or_B",
                user_id: "hashed_user_id",
                test_start_date: "2024-01-01"
              }
            }
          }
        }
      ],
      edges: [
        { id: "edge-1", source: "ab-test-email", target: "ab-test-ad" },
        { id: "edge-2", source: "ab-test-email", target: "ga4-ab-tracking" }
      ]
    },
    metadata: {
      channels: ["email", "ads", "analytics"],
      complexity: "expert",
      setup_time: "75 minutes",
      recommended: true,
      estimated_performance: {
        statistical_significance: "95%",
        minimum_sample_size: "1000 per variant",
        expected_lift: "10-25%"
      },
      best_practices: [
        "Test one variable at a time for clear results",
        "Run tests for at least one full business cycle",
        "Ensure statistical significance before making decisions",
        "Document all test results for future reference",
        "Use holdout groups to measure incrementality"
      ]
    }
  }
])

puts "Created #{CampaignTemplate.count} total templates"
puts "Advanced templates created successfully!"
