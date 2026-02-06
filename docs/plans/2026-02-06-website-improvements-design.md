# Eventism Website Improvements Design

**Date:** 2026-02-06
**Scope:** Frontend mockups with polished UI, mock data, no backend
**Target users:** Attendees, Vendors, Organizers (balanced)

---

## 1. Landing Page (Home)

### 1.1 Hero Section Improvements

**Current problems:**
- Generic headline doesn't differentiate from competitors
- Stats feel placeholder-y (500+ events, 50+ categories)
- No social proof or trust signals
- Three user types aren't clearly addressed

**Changes:**

**Segmented entry points** below search card:
- "Find Events" → `/browse`
- "List Your Event" → Coming soon modal with waitlist signup
- "Find Vendor Opportunities" → `/vendors`

**Enhanced search card:**
- Add city/location dropdown (Sydney, Melbourne, Brisbane, Perth, Adelaide, etc.)
- Popular search suggestions below button: "Markets this weekend", "Food festivals", "Free events"

**Social proof strip** below hero:
- Horizontal scrolling strip of event logos/thumbnails from actual data
- Text: "Trusted by 50+ event organizers across Australia"
- 2-3 short testimonial snippets (mocked)

### 1.2 Below-the-fold Content

**"How it works" section** for each user type:
- Attendees: Discover → Save → Attend
- Vendors: Browse → Apply → Sell
- Organizers: List → Promote → Connect

**Featured events grid** (curated selection)

**Categories showcase** with visual icons

---

## 2. Browse Experience

### 2.1 Filter Improvements

**Collapsible sidebar:**
- Collapsed by default on desktop (more content space)
- Expand icon to reveal full filters
- Sticky position when scrolling

**New filters:**
- Price range: Free, Under $20, $20-50, $50+
- Event size: Intimate (<100), Medium (100-500), Large (500+)
- Distance from city center (when location selected)

**Quick filter chips** above results:
- "This weekend"
- "Free events"
- "Family friendly"
- "Accepting vendors"

### 2.2 Event Card Improvements

**Visual hierarchy:**
- "Featured" badge (gold/amber) on select events
- "Popular" badge based on interest count
- "Vendors Welcome" badge (green) for vendor-accepting events

**Social proof:**
- "X people interested" with subtle icon

**Favorites:**
- Heart icon on each card
- Saves to localStorage (no auth)
- Filled heart when favorited

**Better date display:**
- Format: "Sat, Mar 15" not ISO date
- "Tomorrow", "This weekend" relative labels when applicable

### 2.3 View Options

**Toggle buttons:**
- Grid view (current, default)
- List view (horizontal cards with more info per row)

**Sort dropdown:**
- Date (soonest first) - default
- Popularity (most interested)
- Recently added

### 2.4 Empty States

**No results:**
- Friendly illustration
- Suggest broadening filters
- "Events you might like" fallback grid

---

## 3. Event Detail Page

### 3.1 Enhanced Header

**Banner overlay:**
- Semi-transparent gradient overlay on banner image
- Event name, date, location overlaid on banner
- Organizer logo/name with "Hosted by" label

**Action buttons (top right):**
- Share button (copy link, social icons dropdown)
- Favorite/heart button
- "Add to Calendar" (generates .ics)

### 3.2 Structured Info Sections

**At a glance card:**
- Date & time with calendar icon
- Location with map pin icon
- Price range (Free / $X - $Y)
- Expected attendance
- Tags as colored pills

**About section:**
- Description with "Read more" expansion for long text
- Organizer info card with link to organizer profile

**Location section:**
- Embedded static map preview (OpenStreetMap)
- Full address
- "Get directions" link (opens Google Maps)

**For vendor-accepting events - Vendor Information section:**
- Application deadline with countdown ("5 days left to apply")
- Stall fee range
- What's included (table, power, tent, etc.)
- Requirements (public liability insurance, food permits, etc.)
- "Apply as Vendor" prominent button

### 3.3 CTAs

**Primary CTA:**
- "Get Tickets" or "Register" or "Learn More"
- Links to external ticketing/event page

**Secondary CTAs:**
- "Add to Calendar"
- "Share Event"
- "Apply as Vendor" (when applicable)

### 3.4 Social Proof & Related

**Engagement indicators:**
- "X people interested" counter with heart icon
- Share count (mocked)

**Related events carousel:**
- "You might also like" section at bottom
- Based on same tags or same organizer
- Horizontal scroll on mobile, grid on desktop

---

## 4. Vendor Ecosystem

### 4.1 Vendor Landing Page (`/vendors`)

**Hero section:**
- Headline: "Find Your Next Market" or "Grow Your Business at Amazing Events"
- Subhead: "Connect with event organizers across Australia"
- CTA: "Browse Opportunities" → `/browse?vendors=true`

**Value propositions (3-4 cards):**
- Low application fees
- Direct organizer contact
- Manage your calendar
- Build your reputation

**Featured opportunities:**
- Grid of events currently accepting vendors
- Deadline urgency indicators

**How it works:**
1. Browse events accepting vendors
2. Submit your application
3. Get accepted by organizers
4. Sell at amazing events

**Testimonials:**
- 2-3 vendor testimonials (mocked)
- Photo, name, business type, quote

**CTA section:**
- "Ready to get started?"
- "Browse Opportunities" button
- "Create Vendor Profile" button → interest form modal

### 4.2 Vendor Directory (`/vendors/directory`)

**Search & filters:**
- Search by business name or product type
- Category filter: Food & Beverage, Handmade Crafts, Art & Photography, Fashion & Accessories, Health & Beauty, Home & Garden, Kids & Family, Other
- Location/region filter
- Availability filter (accepting bookings)

**Vendor cards:**
- Cover photo or logo
- Business name
- Category tags (max 3)
- Social icons (website, Instagram, TikTok)
- "View Profile" button

**Pagination or infinite scroll**

### 4.3 Vendor Profile Page (`/vendor/:id`)

**Header:**
- Cover photo / banner
- Logo (circular, overlapping banner)
- Business name
- Tagline / short description
- Social links with icons: Website, Instagram, TikTok

**About section:**
- Full description
- Product categories as tags

**Gallery:**
- Photo grid (stall setup, products, at events)
- Lightbox on click

**Past events:**
- List of events they've attended
- Links to event pages

**Contact section:**
- "Contact Vendor" button → mailto: or modal form
- "Invite to Your Event" button (for organizers, mocked)

---

## 5. Organizer Ecosystem

### 5.1 Organizer Directory (`/organizers`)

**Purpose:** Help vendors discover organizers to pitch/follow

**Search & filters:**
- Search by organization name
- Event types they run (Markets, Festivals, Conferences, etc.)
- Location/region
- "Currently accepting vendors" toggle

**Organizer cards:**
- Logo
- Organization name
- Event types as tags
- Number of events run
- Social icons
- "View Profile" button

### 5.2 Organizer Profile Page (`/organizer/:id`)

**Header:**
- Banner image (from their events or custom)
- Logo
- Organization name
- Tagline
- Social links: Website, Instagram, TikTok

**About section:**
- Description
- Stats: "Runs X events per year", "Y vendors have worked with them"

**Their events:**
- Tabs: Upcoming | Past
- Grid of event cards
- "View all events by [Organizer]" link → browse with filter

**Contact:**
- "Contact Organizer" button
- Social links repeated

---

## 6. Navigation & Footer

### 6.1 Desktop Navigation

**Left side - Logo + primary nav:**
- Eventism logo (clickable → home)
- Events (dropdown):
  - Browse All
  - Map View
  - Calendar
- Vendors (dropdown):
  - Find Vendors (directory)
  - Vendor Opportunities (browse with filter)
  - For Vendors (landing page)
- Organizers
- About

**Right side - CTAs:**
- "List Your Event" button (outlined) → modal/waitlist
- "Join as Vendor" button (filled) → interest form modal

### 6.2 Mobile Navigation

**App bar:** Hamburger menu + Eventism logo

**Drawer:**
- Home
- Events (expandable)
  - Browse All
  - Map View
  - Calendar
- Vendors (expandable)
  - Find Vendors
  - Vendor Opportunities
  - For Vendors
- Organizers
- About
- Divider
- List Your Event
- Join as Vendor

### 6.3 Footer

**4-column layout (desktop):**

**Column 1 - Brand:**
- Eventism logo
- Tagline: "Connecting communities through events"
- Social icons (Instagram, TikTok, Facebook)

**Column 2 - Discover:**
- Browse Events
- Map View
- Calendar
- Categories

**Column 3 - For Vendors:**
- Vendor Opportunities
- Create Vendor Profile
- Vendor Directory
- Vendor FAQ (placeholder)

**Column 4 - For Organizers:**
- List Your Event
- Organizer Directory
- Pricing (placeholder)
- Organizer FAQ (placeholder)

**Bottom bar:**
- Copyright: "2026 Eventism. All rights reserved."
- Links: Privacy Policy | Terms of Service | Contact

**Newsletter signup (above footer columns):**
- "Stay in the loop" headline
- Email input + Subscribe button
- Mocked - shows success toast on submit

---

## 7. Global Polish

### 7.1 Micro-interactions

- Button hover states (subtle lift/shadow)
- Card hover (slight scale + shadow increase)
- Smooth page transitions
- Heart/favorite animation on click
- Toast notifications for actions (favorited, copied link, form submitted)

### 7.2 Loading States

- Skeleton loaders instead of spinners for:
  - Event cards
  - Profile pages
  - Lists
- Shimmer animation on skeletons

### 7.3 Breadcrumbs

**On detail pages:**
- Events > Event Name
- Vendors > Vendor Directory > Vendor Name
- Organizers > Organizer Name

### 7.4 Responsive Breakpoints

Keep existing breakpoint system:
- Mobile: < 600px
- Tablet: 600-1024px
- Desktop: 1024-1440px
- Large desktop: > 1440px

---

## 8. Mock Data Requirements

### New mock data needed:

**Vendors (8-12):**
- id, name, slug, tagline, description
- logo_url, cover_url, gallery_urls[]
- categories[]
- location (city/region)
- social_links: { website, instagram, tiktok }
- past_event_ids[]

**Organizers (5-8):**
- id, name, slug, tagline, description
- logo_url, banner_url
- event_types[]
- location
- social_links: { website, instagram, tiktok }
- event_ids[]

**Enhanced events:**
- Add: organizer_id, expected_attendance, price_range
- Add: vendor_info: { stall_fee, includes[], requirements[] }
- Add: interest_count (mocked number)

**Testimonials (5-6):**
- quote, author_name, author_role, author_image_url
- type: 'vendor' | 'organizer' | 'attendee'

---

## 9. Pages Summary

| Route | Page | Status |
|-------|------|--------|
| `/` | Home (enhanced) | Existing - update |
| `/browse` | Browse events | Existing - update |
| `/map` | Map view | Existing - minor updates |
| `/calendar` | Calendar view | Existing - minor updates |
| `/event/:id` | Event detail | Existing - major update |
| `/about` | About page | Existing - minor updates |
| `/vendors` | Vendor landing page | New |
| `/vendors/directory` | Vendor directory | New |
| `/vendor/:id` | Vendor profile | New |
| `/organizers` | Organizer directory | New |
| `/organizer/:id` | Organizer profile | New |

---

## 10. Out of Scope

- User authentication / accounts
- Event creation flow for organizers
- Real form submissions (all forms show success toast, no backend)
- Payment processing
- Admin dashboard
- Email notifications
- Mobile app (Flutter web only)

---

## 11. Success Criteria

The improved site should:
1. Clearly communicate value to all three user types within 5 seconds
2. Make event discovery intuitive with smart filters and good empty states
3. Provide rich event detail pages that answer attendee questions
4. Give vendors a clear path to find and apply for opportunities
5. Allow organizers to discover vendors for their events
6. Feel polished with consistent interactions and loading states
7. Work well on desktop and tablet (mobile functional but not primary focus)
