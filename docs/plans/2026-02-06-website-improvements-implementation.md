# Eventism Website Improvements - Implementation Plan

**Date:** 2026-02-06
**Design doc:** `2026-02-06-website-improvements-design.md`
**Approach:** Incremental implementation, foundation first, then features

---

## Phase 1: Foundation & Data Models

### 1.1 Create mock data models and providers

**Files to create:**
- `lib/data/models/vendor.dart` - Vendor model with JSON serialization
- `lib/data/models/vendor.g.dart` - Generated JSON code
- `lib/data/models/organizer.dart` - Organizer model
- `lib/data/models/organizer.g.dart` - Generated JSON code
- `lib/data/models/testimonial.dart` - Testimonial model
- `lib/data/providers/vendors_provider.dart` - Vendor data provider
- `lib/data/providers/organizers_provider.dart` - Organizer data provider

**Vendor model fields:**
```dart
String id, name, slug, tagline, description
String? logoUrl, coverUrl
List<String> galleryUrls, categories, pastEventIds
String? location, website, instagram, tiktok
```

**Organizer model fields:**
```dart
String id, name, slug, tagline, description
String? logoUrl, bannerUrl
List<String> eventTypes, eventIds
String? location, website, instagram, tiktok
```

### 1.2 Enhance Event model

**Update `lib/data/models/event.dart`:**
- Add `organizerId` field
- Add `expectedAttendance` field
- Add `priceRange` field (String like "Free" or "$20-50")
- Add `interestCount` field (int, mocked)
- Add `vendorInfo` embedded object:
  - `stallFee` (String)
  - `includes` (List<String>)
  - `requirements` (List<String>)
- Add `isFeatured` field (bool)

### 1.3 Create mock data JSON files

**Files to create:**
- `assets/data/vendors.json` - 10 mock vendors
- `assets/data/organizers.json` - 6 mock organizers
- `assets/data/testimonials.json` - 6 testimonials

**Update:**
- `assets/data/events.json` - Add new fields to existing events

### 1.4 Local favorites service

**File to create:**
- `lib/data/services/favorites_service.dart`
  - Uses SharedPreferences
  - `getFavorites()`, `addFavorite(id)`, `removeFavorite(id)`, `isFavorite(id)`
- `lib/data/providers/favorites_provider.dart`
  - Riverpod provider wrapping the service

---

## Phase 2: Shared Components

### 2.1 UI components

**Files to create:**
- `lib/shared/widgets/social_links.dart` - Row of social icons (website, instagram, tiktok)
- `lib/shared/widgets/badge.dart` - Reusable badge (Featured, Popular, Vendors Welcome)
- `lib/shared/widgets/favorite_button.dart` - Heart icon with animation, uses favorites provider
- `lib/shared/widgets/skeleton_loader.dart` - Shimmer skeleton for loading states
- `lib/shared/widgets/toast_service.dart` - Global toast/snackbar helper
- `lib/shared/widgets/breadcrumbs.dart` - Breadcrumb navigation component
- `lib/shared/widgets/section_header.dart` - Consistent section headers with optional "View all" link
- `lib/shared/widgets/empty_state.dart` - Reusable empty state with icon, title, subtitle, action

### 2.2 Update theme

**Update `lib/core/theme.dart`:**
- Add badge colors (featured: amber, popular: blue, vendors: green)
- Add skeleton shimmer colors
- Ensure consistent spacing constants

### 2.3 Update constants

**Update `lib/core/constants.dart`:**
- Add vendor categories list
- Add organizer event types list
- Add price range options
- Add event size options

---

## Phase 3: Navigation & Layout

### 3.1 Update shell scaffold with new navigation

**Update `lib/shared/widgets/shell_scaffold.dart`:**
- Desktop nav with dropdowns (Events, Vendors)
- Add Organizers link
- Dual CTA buttons (List Your Event, Join as Vendor)
- Mobile drawer with expandable sections

### 3.2 Create footer component

**File to create:**
- `lib/shared/widgets/footer.dart`
  - 4-column layout
  - Newsletter signup (mocked)
  - Social icons
  - Legal links

### 3.3 Update router

**Update `lib/core/router.dart`:**
- Add `/vendors` route
- Add `/vendors/directory` route
- Add `/vendor/:id` route
- Add `/organizers` route
- Add `/organizer/:id` route

---

## Phase 4: Landing Page (Home)

### 4.1 Update hero section

**Update `lib/features/home/widgets/hero_section.dart`:**
- Add city/location dropdown to search card
- Add popular search suggestions below button
- Add segmented entry points (Find Events, List Your Event, Find Vendor Opportunities)

### 4.2 Create social proof strip

**File to create:**
- `lib/features/home/widgets/social_proof_strip.dart`
  - Horizontal scroll of event thumbnails
  - "Trusted by X organizers" text
  - Testimonial snippets

### 4.3 Create how it works section

**File to create:**
- `lib/features/home/widgets/how_it_works.dart`
  - Three columns for attendees, vendors, organizers
  - Step-by-step icons and text

### 4.4 Update home page

**Update `lib/features/home/home_page.dart`:**
- Add social proof strip below hero
- Add how it works section
- Update featured events section

---

## Phase 5: Browse Experience

### 5.1 Update filter sidebar

**Update `lib/features/browse/widgets/filter_sidebar.dart`:**
- Make collapsible (collapsed by default on desktop)
- Add price range filter
- Add event size filter
- Add distance filter (when location selected)

### 5.2 Create quick filter chips

**File to create:**
- `lib/features/browse/widgets/quick_filters.dart`
  - "This weekend", "Free events", "Family friendly", "Accepting vendors"
  - Horizontal scrollable row

### 5.3 Update event card

**Update `lib/features/browse/widgets/event_card.dart`:**
- Add Featured/Popular/Vendors Welcome badges
- Add "X people interested" indicator
- Add favorite button (heart icon)
- Better date formatting ("Sat, Mar 15", "Tomorrow", "This weekend")
- Hover state improvements

### 5.4 Create list view card

**File to create:**
- `lib/features/browse/widgets/event_list_item.dart`
  - Horizontal card layout for list view
  - More info visible (description preview, all tags)

### 5.5 Update browse page

**Update `lib/features/browse/browse_page.dart`:**
- Add view toggle (grid/list)
- Add sort dropdown
- Integrate quick filter chips
- Collapsible sidebar
- Better empty state with suggestions

### 5.6 Update browse provider

**Update `lib/features/browse/browse_provider.dart`:**
- Add price range filter
- Add event size filter
- Add sort options (date, popularity, recent)
- Add view mode state (grid/list)

---

## Phase 6: Event Detail Page

### 6.1 Update event header

**Update `lib/features/event_detail/widgets/event_header.dart`:**
- Gradient overlay on banner
- Event name, date, location overlaid
- Organizer logo with "Hosted by" label

### 6.2 Create action buttons component

**File to create:**
- `lib/features/event_detail/widgets/action_buttons.dart`
  - Share button with dropdown (copy link, social)
  - Favorite button
  - Add to calendar button

### 6.3 Update event info

**Update `lib/features/event_detail/widgets/event_info.dart`:**
- "At a glance" card with icons
- Structured sections with headers
- Expandable description
- Location with map preview
- Link to organizer profile

### 6.4 Create vendor info section

**File to create:**
- `lib/features/event_detail/widgets/vendor_info_section.dart`
  - Application deadline with countdown
  - Stall fee, includes, requirements
  - "Apply as Vendor" button
  - Only shows for vendor-accepting events

### 6.5 Create related events section

**File to create:**
- `lib/features/event_detail/widgets/related_events.dart`
  - Horizontal carousel of related events
  - Based on same tags or same organizer

### 6.6 Update CTA buttons

**Update `lib/features/event_detail/widgets/cta_buttons.dart`:**
- Primary: Get Tickets / Register
- Secondary: Add to Calendar, Share
- Vendor CTA when applicable

### 6.7 Update event detail page

**Update `lib/features/event_detail/event_detail_page.dart`:**
- Add breadcrumbs
- Integrate all new sections
- Add social proof indicators
- Add related events at bottom

---

## Phase 7: Vendor Ecosystem

### 7.1 Create vendor landing page

**Files to create:**
- `lib/features/vendors/vendors_landing_page.dart`
  - Hero section
  - Value propositions grid
  - Featured opportunities
  - How it works steps
  - Testimonials
  - CTA section

### 7.2 Create vendor directory page

**Files to create:**
- `lib/features/vendors/vendor_directory_page.dart`
  - Search bar
  - Filter sidebar (category, location, availability)
  - Vendor cards grid
  - Pagination
- `lib/features/vendors/widgets/vendor_card.dart`
  - Cover photo, logo, name, categories, social icons
- `lib/features/vendors/widgets/vendor_filters.dart`
  - Category, location, availability filters
- `lib/features/vendors/vendor_directory_provider.dart`
  - Search, filter, pagination state

### 7.3 Create vendor profile page

**Files to create:**
- `lib/features/vendors/vendor_profile_page.dart`
  - Header with cover, logo, social links
  - About section
  - Photo gallery
  - Past events list
  - Contact buttons
- `lib/features/vendors/widgets/vendor_header.dart`
- `lib/features/vendors/widgets/vendor_gallery.dart`
- `lib/features/vendors/widgets/vendor_events.dart`

---

## Phase 8: Organizer Ecosystem

### 8.1 Create organizer directory page

**Files to create:**
- `lib/features/organizers/organizer_directory_page.dart`
  - Search bar
  - Filter sidebar (event types, location, accepting vendors)
  - Organizer cards grid
- `lib/features/organizers/widgets/organizer_card.dart`
- `lib/features/organizers/widgets/organizer_filters.dart`
- `lib/features/organizers/organizer_directory_provider.dart`

### 8.2 Create organizer profile page

**Files to create:**
- `lib/features/organizers/organizer_profile_page.dart`
  - Header with banner, logo, social links
  - About section with stats
  - Events tabs (Upcoming / Past)
  - Contact section
- `lib/features/organizers/widgets/organizer_header.dart`
- `lib/features/organizers/widgets/organizer_events.dart`

---

## Phase 9: Polish & Modals

### 9.1 Create modal dialogs

**Files to create:**
- `lib/shared/widgets/modals/waitlist_modal.dart` - "List Your Event" waitlist signup
- `lib/shared/widgets/modals/vendor_signup_modal.dart` - "Join as Vendor" interest form
- `lib/shared/widgets/modals/vendor_apply_modal.dart` - Apply as vendor to specific event
- `lib/shared/widgets/modals/share_modal.dart` - Share event with copy link, social icons

### 9.2 Add loading skeletons

**Update pages to use skeleton loaders:**
- Browse page (event card skeletons)
- Event detail page
- Vendor directory
- Organizer directory
- Profile pages

### 9.3 Add toast notifications

**Integrate toasts for:**
- Favorited/unfavorited event
- Copied link to clipboard
- Form submitted successfully
- Added to calendar

### 9.4 Update About page

**Update `lib/features/about/about_page.dart`:**
- Update stats to feel more real
- Add "For Vendors" and "For Organizers" sections
- Update CTAs to link to new pages

### 9.5 Minor updates to Map and Calendar

**Update `lib/features/map/map_page.dart`:**
- Add favorite button to event popup
- Add breadcrumbs

**Update `lib/features/calendar/calendar_page.dart`:**
- Add favorite button to event list items
- Improved date selection feedback

---

## Phase 10: Final Polish

### 10.1 Responsive testing and fixes

- Test all new pages at all breakpoints
- Fix any overflow or layout issues
- Ensure touch targets are adequate on tablet

### 10.2 Animation and transitions

- Page transition consistency
- Button hover/press states
- Card hover effects
- Favorite heart animation

### 10.3 Accessibility check

- Semantic labels on interactive elements
- Color contrast verification
- Keyboard navigation (tab order)

### 10.4 Code cleanup

- Remove unused code
- Consistent naming
- Add brief comments where helpful
- Run `dart fix --apply`
- Run `flutter analyze`

---

## Implementation Order Summary

| Phase | Description | Dependencies |
|-------|-------------|--------------|
| 1 | Foundation & Data Models | None |
| 2 | Shared Components | Phase 1 |
| 3 | Navigation & Layout | Phase 2 |
| 4 | Landing Page | Phase 2, 3 |
| 5 | Browse Experience | Phase 2 |
| 6 | Event Detail | Phase 2, 5 |
| 7 | Vendor Ecosystem | Phase 1, 2, 3 |
| 8 | Organizer Ecosystem | Phase 1, 2, 3 |
| 9 | Polish & Modals | Phase 4-8 |
| 10 | Final Polish | Phase 9 |

---

## File Count Estimate

| Category | New Files | Updated Files |
|----------|-----------|---------------|
| Models | 5 | 1 |
| Providers | 5 | 2 |
| Data/Assets | 3 | 1 |
| Shared widgets | 12 | 1 |
| Core | 0 | 3 |
| Home feature | 2 | 2 |
| Browse feature | 3 | 4 |
| Event detail | 4 | 4 |
| Vendors feature | 9 | 0 |
| Organizers feature | 7 | 0 |
| Modals | 4 | 0 |
| Other pages | 0 | 3 |
| **Total** | **54** | **21** |

---

## Risk Mitigation

**Risk:** Scope creep during implementation
**Mitigation:** Stick to design doc, defer "nice to haves" to future iteration

**Risk:** Mock data doesn't feel realistic
**Mitigation:** Use real Australian event names, locations, and plausible details

**Risk:** Performance with many new components
**Mitigation:** Use const constructors, lazy loading for images, pagination

---

## Definition of Done

Each phase is complete when:
1. All listed files are created/updated
2. Code compiles without errors
3. Basic functionality works (navigation, data display)
4. Responsive at desktop and tablet breakpoints
5. No obvious visual bugs

Final completion when:
1. All 10 phases complete
2. Full user journey works for all three user types
3. `flutter analyze` passes
4. Manual testing on Chrome desktop and tablet viewport
