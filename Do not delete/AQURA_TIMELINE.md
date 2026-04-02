# Ruyax Development Timeline

> **Total Commits: 232** | December 31, 2025 â†’ February 12, 2026  
> Repository: `mkyousafali/Ruyax`

---

## ðŸ“… December 2025

### December 31, 2025 (3 commits)
- ðŸš€ **Initial commit** â€” Clean repository (AQ32.12.7.7)
- ðŸ”’ Remove remaining hardcoded keys and deprecated function
- ðŸ› Fix date range calculation for last day of month in PaidManager

---

## ðŸ“… January 2026

### January 1, 2026 (5 commits)
- ðŸ§¾ Fix voucher issue receipt: bilingual template, table format, total value, print popup window, PV code format
- ðŸ”§ Fix Supabase env vars in API endpoint for Vercel build
- ðŸ—‘ï¸ Remove unused purchase-vouchers API endpoint
- ðŸ“ Add better error logging for user creation
- ðŸ’° Update finance voucher components and add receipts bucket migration

### January 2, 2026 (1 commit)
- ðŸ“¦ **Purchase Voucher Manager improvements:** Status cards with stats, branch selection for internal stock transfer, PV ID exact match search, book-wise and voucher-wise views with pagination

### January 3, 2026 (3 commits)
- ðŸ”„ Fix stock transfer workflow and add realtime updates to purchase voucher components
- ðŸ” Purchase voucher improvements: close gift with expense, search by PV ID/serial, closed stats card
- ðŸ› Fix fetch errors and race conditions in PurchaseVoucher components

### January 4, 2026 (3 commits)
- ðŸ“± Add mobile PV Manager with i18n, permission control, RTL support, and currency icon sizing
- ðŸ“Š Add book count display to mobile purchase voucher manager
- ðŸ’µ **Denomination feature:** ERP balance comparison, Suspends panel with Paid/Received sections

### January 6, 2026 (6 commits)
- ðŸ› Fix box_operations status constraint to support `pending_close` status
- â° Add recharge card transaction date/time saving to CloseBox and ClosingDetails
- ðŸ“¸ Add POS before closing image save feature, logo to thermal receipt, auto-save to storage bucket
- ðŸ› Fix Supabase client initialization error in deployed version
- ðŸ› Restore missing upload logic to `saveA4AsPNG` function
- ðŸ› Fix import supabase client from utils instead of creating new instance

### January 7, 2026 (5 commits)
- ðŸŽ¨ Fix CloseBox and ClosingDetails layout/styling â€” reduce spacing, add orange borders, optimize card sizes, make fields readonly, display supervisor name
- ðŸ› Fix: Logout button in cashier taskbar now works
- ðŸ› Fix: Include purchase vouchers in autosave for close box details
- ðŸŽ¨ Optimize electronic signature card layout and spacing
- âœ… Add voucher status check feature to CompleteBox and fix denomination loading

### January 8, 2026 (3 commits)
- ðŸ“‹ **Closed Boxes viewer** with completed operations tracking and imperial green styling
- ðŸ”’ RLS policies for `hr_employee_master` table and save all users in LinkID
- ðŸ’° **Denomination transaction system** with modals, tables, delete confirmation, and notification popups

### January 9, 2026 (5 commits)
- ðŸ› Fix CompleteBox and CompletedBoxDetails: Update base values immediately on edit, load complete_details properly
- âž• Add 3 new POS advance boxes (E1, E2, E3) â€” boxes 10, 11, 12
- ðŸŽ¨ Add special styling for extra cash boxes (E1-E3)
- âœ¨ Progressive disclosure workflow with numbered checkboxes, ERP popup modal, and green checkmarks
- ðŸ‘¤ **Employee ID mapping:** Double-click edit, clear button, EMP ID format, batch save for 100k+ users

### January 10, 2026 (5 commits)
- ðŸ› Fix EMP ID duplicate issue, add status column, auto-load users, highlight inactive users in red
- ðŸŽ¨ Replace browser alerts with custom success modal + Arabic translations
- ðŸŽ¨ Adjust CloseBox UI: reduce recharge card height, increase time input width
- ðŸ› Fix time loading in CompleteBox: parse recharge_transaction times
- â° Add recharge card section to CounterCheck with start date, time, and opening balance

### January 11, 2026 (3 commits)
- ðŸ–¼ï¸ Add PA logo to CompleteBox print header and fix cashier name reactive parsing
- ðŸŽ¨ Restructure denomination layout: moved branch selector and completed ops cards
- ðŸŽ¨ Optimize branch selector: move button to same line as dropdown

### January 12, 2026 (11 commits)
- â° Auto-fill recharge card date/time and remove opening balance field
- ðŸ“Š Auto-load denomination counts and make specific boxes read-only
- ðŸŽ¨ Fix balance cards layout â€” display side by side
- ðŸ”’ Make all fields read-only and disable Add to Denomination in CompletedBoxDetails
- ðŸ› Fix difference calculation formula â€” update labels to Real Cash is Excess/Short
- ðŸ› Fix recharge card sales calculation formula (closing-opening)
- âœ… Removed bulk approval, added inline accept/reject buttons (desktop + mobile)
- ðŸ“± Updated mobile: added button names to dropdown, reorganized navigation, fixed fingerprint display
- ðŸŽ¨ Updated mobile dashboard: button colors, Active POS card with purple styling
- ðŸ” Added amount filter to POS Report
- ðŸ¦ **Bank Reconciliation** with 8 bank/card buttons and XLSX import

### January 13, 2026 (6 commits)
- ðŸ“‹ Update receiving task completion and vendor payment schedule migrations
- ðŸ“± Update mobile: change box labels to POS, conditionally display cards
- âœï¸ Add edit functionality to VendorPendingPayments with modal
- ðŸ’° Fix petty cash real-time updates: add +/- buttons, improve subscriptions
- ðŸ—‘ï¸ Remove manual HR management components (replaced by automatic sync)
- ðŸ—‘ï¸ Complete warning system removal: delete all warning components

### January 14, 2026 (5 commits)
- ðŸ‘† **Fingerprint Transactions viewer** with real-time updates, pagination, and advanced filtering
- ðŸ’° **HR Salary and Wage management** with basic salary, other allowance, and payment modes
- ðŸ‘¤ Add sponsorship status toggle to EmployeeFiles
- ðŸ› Fix edit buttons and bank info loading in EmployeeFiles
- ðŸ“‹ Add health educational renewal date, personal information card (DOB/join date), work permit expiry

### January 15, 2026 (3 commits)
- âœ… Add probation period finished badge and update expiry message
- ðŸŽ¨ Change color scheme to orange, green, and white throughout
- ðŸ“… **Day Off (weekday-wise)** feature and UI improvements

### January 16, 2026 (7 commits)
- ðŸ’¼ Add position name column and filter to employee search table
- ðŸ”„ Update Sidebar and parse-sidebar-code API endpoint
- ðŸ’³ **POS Deduction Transfer** with filters and pagination
- ðŸ’³ POS deduction transfers system with status tracking
- âœï¸ Add voucher edit and add functionality to CompleteBox
- âš–ï¸ **Discipline HR module** with auto-generated IDs
- ðŸ½ï¸ Add food allowance to salary management system

### January 17, 2026 (7 commits)
- ðŸ› Fix employee sorting priority and reactivity in ShiftAndDayOff
- ðŸŒ Add missing translation keys for employee files
- ðŸ‘¤ Update employment statuses: Remote Job, Job (No Finger), Job (With Finger)
- ðŸ› Implement reactive filtering and robust ID handling for shift management
- ðŸŒ Add nationality creation and highlight missing master records in LinkID
- ðŸ› Complete fingerprint processing workflow with sequence ID generation
- ðŸ› Implement date-aware shift validation with dynamic buffers

### January 18, 2026 (9 commits)
- ðŸ‘† **Employee fingerprint analysis** with overnight shift support, early/late/overtime badges, sticky header
- ðŸ“‹ Add Leave Request button to HR Operations section
- ðŸ› Fix overnight shift logic: load `is_shift_overlapping_next_day`
- â° Update ShiftAndDayOff UI to 12h format and fix RTL dropdown arrows
- ðŸŒ Implement i18n for Discipline page
- âœ… Display selected employee name in day-off approval requests
- ðŸ”„ Implement real-time synchronization for analysis, shift, and salary modules
- ðŸ“ Add description field to day off requests
- ðŸ“± Add Human Resources menu to mobile bottom navigation

### January 19, 2026 (12 commits)
- ðŸ“± Mobile Fingerprint Analysis: day off, leave status, missing punch indicators
- ðŸ“Š **Bulk Fingerprint Analysis (Analyze All)** with RTL support
- ðŸ¢ Update cashier login branch dropdown for locale
- ðŸ› Bulk fingerprint analysis fixes and localized cashier selection
- ðŸ“ Comprehensive VersionChangelog update for AQ34.13.8.8
- ðŸ“ Create Versioning and Changelog Update Guide
- ðŸ› Fix sync status with proper pairing logic for 'Other' punch classification
- ðŸ“ Update changelog with punch sync fix details
- ðŸ“ Update version workflow guide
- ðŸ› Fix close div in VersionChangelog
- ðŸ› Fix changelog version display to AQ36.14.9.9
- ðŸ’° **Net Salary, Net Bank, Net Cash** calculation columns in salary statement

### January 20, 2026 (3 commits)
- ðŸ’° **POS Shortage Deduction Logic** in salary statement with forgive checkboxes
- ðŸ› Fix HR menu popup positioning for RTL (Arabic)
- ðŸŒ Fix missing translation keys and add special shift date range feature

### January 21, 2026 (7 commits)
- ðŸ› Fix mobile notification center auto-loading
- ðŸ› Remove limit(100) from markAllAsRead
- ðŸ› Fix Tasks section button permissions and mobile branch performance
- ðŸ‘¤ Display employee names/IDs from `hr_employee_master` in user management
- ðŸ› Fix LinkID employee editing bug â€” Use user ID instead of array index
- âœï¸ Add comprehensive edit functionality and status management
- ðŸ”” **Push notification system** with desktop and mobile support

### January 22, 2026 (1 commit)
- ðŸ› Fix day-off request handlers in mobile approval center

### January 23, 2026 (1 commit)
- ðŸ”€ Move FINGERPRINT_TRANSACTIONS to HR Reports, remove LEAVES_AND_VACATIONS from Operations

### January 27, 2026 (3 commits)
- ðŸ› Fix reconciliation entries: show POS number and cashier name
- ðŸ› Fix reconciliation transfer logic for all scenarios
- ðŸ› Update excess entries to always transfer to POS Excess account

### January 30, 2026 (2 commits)
- ðŸ“… Add employment status effective date and worked duration calculation
- ðŸ› Fix product schema, optimize offer editor performance

### January 31, 2026 (2 commits)
- ðŸ” Add search bar to PricingManager, fix VariationManager references
- ðŸ”„ Add realtime subscriptions for PricingManager, ProductMaster, VariationManager

---

## ðŸ“… February 2026

### February 1, 2026 (3 commits)
- ðŸ”¢ Add invalid product count badge to Generate Offers button
- ðŸ“Š **Overdues Report:** Vendor/Expense tables with export, branch+location display
- ðŸš¨ Add incident report permission and ReportIncident improvements

### February 2, 2026 (3 commits)
- ðŸ”„ Allow resending rejected approval requests with Resend button
- ðŸ” Add Finance and Customer/POS incident permissions with dynamic routing
- ðŸ› Fix branch dropdown in ReportIncident sidebar mode

### February 3, 2026 (3 commits)
- ðŸ“± Mobile UI: Add Tasks menu with submenu, move Home to top bar, add Incident Manager with badge
- ðŸ› Fix mobile submenu positioning â€” center all bottom nav submenus
- âœ… Incident follow-up task completion blocked until resolved, bilingual notifications

### February 4, 2026 (8 commits)
- ðŸ› Fix vendor payment approval: Only send to selected approver
- ðŸ”„ Add refresh button to MonthlyManager
- ðŸ› Fix file upload: Sanitize Arabic filenames for expense bills
- ðŸ·ï¸ Display selected offer name in Step 3 review
- ðŸ“‹ **Page/order tracking** for flyer offer products with multi-category filter
- ðŸ¤– **AI group name generator**, category filter in VariationManager
- ðŸ› Fix variant modal only includes group products
- âœ¨ Create variant group from OfferProductSelector with AI naming

### February 5, 2026 (6 commits)
- ðŸ“Š **View All Paid** windows with filters and Excel export for vendor/expense payments
- ðŸ“Š Add sticky header, filters, and Excel export to AllVendorPaid/AllExpensePaid
- ðŸ–¼ï¸ **Update app logo** to new Ruyax logo across all interfaces
- ðŸ› Fix pnpm-lock.yaml
- ðŸŽ¨ Hide columns and update header in ERP Entry Manager
- ðŸ–¨ï¸ Automatic grid layout for variant images in shelf paper PDFs

### February 6, 2026 (3 commits)
- ðŸ–¨ï¸ Add page/order columns and print to shelf paper manager
- ðŸ“‹ Add double-click copy with formatted date for offer types
- ðŸ” Add search bar, B8-B11 pricing buttons, fix field name handling

### February 7, 2026 (5 commits)
- ðŸ› Fix: Sync total_offer_price and total_sales_price for variant products
- ðŸŽ¨ Add color coding to offer decrease column
- ðŸ“Š Add serial numbers, reorder columns, format dates, color-code offer end dates in export
- ðŸŽ¨ **Custom font upload** and per-field font selection for shelf paper templates
- ðŸ–¼ï¸ Improve flyer generator with image handling, Arabic text, and export fixes

### February 8, 2026 (9 commits)
- ðŸ–¼ï¸ Add individual image movement for offer_qty products
- ðŸ› Preserve individual image positions/sizes in PNG export
- âœ¨ Add `variant_icon` field type for flyer templates
- âœ¨ Add `expiry_date_label` field type
- ðŸ—‘ï¸ Remove SVG/PDF/Print export, update price strikethrough, add dates to PNG filename
- ðŸ“„ Add page numbers and rotation support to flyer system
- ðŸŽ¨ Match page number button design with action buttons
- ðŸ”§ Update pnpm-lock.yaml
- ðŸ“„ **Normal Paper Manager** with template download, Excel import, table display, and scannable barcode printing

### February 9, 2026 (6 commits)
- ðŸŒ Add logout confirmation translations and fix nav.cancel key
- ðŸ› Preserve pricing data in Offer Product Editor (upsert instead of delete+reinsert)
- ðŸ–¨ï¸ Shelf paper: parallel load, template loading indicator, select-all size buttons, offer_qty image grid
- ðŸ“ Changelog update for AQ39 â€” shelf paper, offer editor, favorites, flyer
- ðŸ·ï¸ **One Day Offer Manager** with import, pricing, print, and barcode export
- ðŸ“ Changelog update for AQ40

### February 10, 2026 (7 commits)
- ðŸ› Fix product creation ID generation and variation group queries
- ðŸ› Fix uppercase AI-generated English group name
- ðŸ·ï¸ Add offer name creation, flyer generator improvements, HR checklist module
- ðŸ“‹ **HR checklist operations** with View Answers and Report Problem button
- ðŸ‘† **Punch display:** Last 2 punches across all branches using `hr_employee_master`
- â­ **Drag-and-drop reordering** for favorite buttons with auto-save
- ðŸ› Fix/revert SalesReport realtime subscription

### February 11, 2026 (16 commits)
- ðŸ“Š Styled **Export Excel** added to AnalyzeAllWindow with i18n keys
- âœ… Remove browser alerts from approval permissions, optimize refresh
- ðŸ”§ Update pnpm lock file (xlsx-js-style)
- ðŸ“‹ **Daily Checklist fix:** auto-save with persistent auth, hide user ID, fix infinite loop
- ðŸ“Š Pending checklists count on home page, enhanced checklist UI
- ðŸ“± Mobile: pending checklists counter and submission tracking
- ðŸ“ Changelog update for AQ40.15
- ðŸš¨ Improve incident management and reporting
- ðŸ‘ï¸ Add eye icon to incident reports count
- ðŸ› Fix missing MY_DAILY_CHECKLIST button detection
- ðŸ› Fix: save logged user branch_id to hr_checklist_operations
- ðŸ“¦ **Products Dashboard:** modernized UI with search/filter features
- ðŸ·ï¸ **Shelf Paper:** loading indicators, copy template, font manager, app notifications
- ðŸ·ï¸ Add Shelf Paper Template Designer button to Media â†’ Manage
- â° **Taskbar:** My Daily Checklist button with pending count badge
- ðŸŒ **Sidebar:** language switch and compact online indicator

### February 12, 2026 (6 commits)
- ðŸŽ¨ **Theme System:** desktop interface theme management with CSS variables, persists on reload
- ðŸ’ƒ **Dancing Character:** Lottie animation with bilingual greetings on desktop
- ðŸ¤– **AI Chat System:** Ruyax bot with TTS voice selection, sales report integration, voice input
- ðŸ“Š **Enhanced Sales Report:** comparisons, voice input, full dates
- ðŸ“± Mobile AI chat: cleanup, icon-only bottom nav
- ðŸ“¦ **Receiving overhaul:** branch default positions, clearance certificate improvements, default branch for receiving, UI cleanup
- âš ï¸ **Info card** on welcome screen, changelog date fix, version badge on login

---

## ðŸ“Š Summary

| Month | Commits | Key Features |
|-------|---------|-------------|
| **Dec 2025** | 3 | Initial commit, security cleanup |
| **Jan 2026** | 128 | POS/Finance system, HR modules, Fingerprint analysis, Denomination, Salary management, Push notifications |
| **Feb 2026** | 101 | Flyer system, Shelf paper, Products dashboard, AI chat, Theme system, Receiving defaults, Incident manager |
| **Total** | **232** | |

### Major Milestones
| Version | Date | Highlights |
|---------|------|-----------|
| **AQ32** | Dec 31 | Initial release |
| **AQ33** | Jan 16 | Finance, POS, Denomination, Discipline |
| **AQ34** | Jan 19 | HR Fingerprint Analysis, Salary, Day Off |
| **AQ36** | Jan 19 | Punch sync fix, Salary statement |
| **AQ37** | Jan 21 | User management, Push notifications |
| **AQ38** | Feb 3 | Flyer templates, Incident manager |
| **AQ39** | Feb 9 | Shelf paper, Offer editor, Normal paper |
| **AQ40** | Feb 9 | One Day Offer Manager, Products dashboard |
| **AQ41** | Feb 12 | AI Chat, Theme system, Receiving defaults |

