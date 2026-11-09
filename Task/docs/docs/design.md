# BillCloud Existing Design System

## Scope

This document records design-system details that already exist in the BillCloud frontend source. It does not introduce new colors, spacing, components, or conventions.

Reviewed applications:

- `frontend_angular/`: main authenticated portal.
- `searchBill/`: public invoice lookup frontend.

Primary style entry points:

- `frontend_angular/angular.json`
- `frontend_angular/src/assets/scss/layout.scss`
- `frontend_angular/src/assets/scss/_variables.scss`
- `frontend_angular/src/assets/scss/_base.scss`
- `frontend_angular/src/assets/scss/_overrides.scss`
- `frontend_angular/src/assets/scss/custom/*.scss`
- `searchBill/angular.json`
- `searchBill/src/styles.css`
- `searchBill/src/app/shared/core.less`
- `searchBill/src/app/shared/layout/layout.less`
- `searchBill/src/assets/common/styles/themes/*/*.less`

## Style Foundations

### frontend_angular

`frontend_angular/angular.json` loads one global style entry:

```text
src/assets/scss/layout.scss
```

`layout.scss` imports:

- `frontend_angular/src/assets/scss/_variables.scss`
- `frontend_angular/src/assets/scss/_base.scss`
- `frontend_angular/src/assets/scss/custom/custom`
- `frontend_angular/src/assets/scss/_overrides.scss`

`_base.scss` imports Bootstrap-related plugin styles, Font Awesome, PrimeNG Bootstrap theme, PrimeIcons, Metronic vendor styles, Line Awesome, Flaticon, JCrop, and custom PrimeNG file-upload/autocomplete styles.

### searchBill

`searchBill/angular.json` loads vendor styles directly, followed by application styles:

- Bootstrap plugins.
- Font Awesome.
- PrimeNG and PrimeNG Bootstrap theme.
- PrimeIcons.
- Metronic vendor styles.
- Line Awesome.
- Flaticon.
- PrimeNG file-upload/autocomplete overrides.
- `searchBill/src/app/shared/core.less`.
- `searchBill/src/app/shared/layout/layout.less`.
- `searchBill/src/assets/fonts/fonts-poppins.css`.
- `searchBill/src/assets/fonts/fonts-roboto.css`.
- `searchBill/src/styles.css`.

Theme CSS is also appended dynamically from `searchBill/src/shared/helpers/LocalizedResourcesHelper.ts`, including Metronic `style.bundle`, PrimeNG datatable CSS, theme datatable CSS, `metronic-customize.css`, and theme-specific customizations.

## Colors

### frontend_angular Colors

Defined variables in `frontend_angular/src/assets/scss/_variables.scss`:

| Token | Value |
| --- | --- |
| `--text-color` | `#413b55` |
| `--color-disabled` | `#e9ecef` |
| `--color-theme` | `#bee5eb` |
| `--border-radius` | `0.25rem` |
| `$linkColor` | `#2196f3` |

Global and utility colors:

| Selector / Context | Value | Source |
| --- | --- | --- |
| `body` background | `#f8f8f8` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `body` text | `var(--text-color)` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `.bg-color` | `var(--color-theme)` | `frontend_angular/src/assets/scss/custom/_color.scss` |
| `.bg-disabled` | `var(--color-disabled)` | `frontend_angular/src/assets/scss/custom/_color.scss` |
| `.text-color` | `var(--text-color)` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `.modal .modal-content .modal-header` | `#038599` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `#m_login` | `#36a0b1` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `.text-edit` | `#117a8b` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `.text-view` | `#007bff` | `frontend_angular/src/assets/scss/_overrides.scss` |

Metronic/Bootstrap variables are present in built Metronic CSS under `frontend_angular/build/assets/.../style.bundle.css`, including:

| Token | Value |
| --- | --- |
| `--primary` | `#0747a6` |
| `--primary-hover` | `#062a63` |
| `--primary-active` | `#0062cc` |
| `--border-color` | `#dee2e6` |
| `--border-table-color` | `#f4f5f8` |

### searchBill Colors

Global colors in `searchBill/src/styles.css`:

| Selector / Context | Value |
| --- | --- |
| `body` background | `#f0f0ff` |
| Top menu background | `#0747a6` inline in `top-bar-menu.component.html` |
| Top menu link text | `#deebff` inline in `top-bar-menu.component.html` |
| Menu hover text | `#7bbb2a` |
| Tooltip text | `#000` |
| Tooltip background / arrow | `#fbaa00` |

Theme accent colors from `searchBill/src/assets/common/styles/themes/*/metronic-customize.less`:

| Theme | Primary Border | Active Menu Background | Active Text/Icon |
| --- | --- | --- | --- |
| `default` | `#5867dd` | `#ededfd` | `#716aca` |
| `blue` | `#58A3DC` | `#ECF6FD` | theme file value |
| `green` | `#58DCC2` | `#ECFDF9` | theme file value |
| `pink` | `#DC586E` | `#FDECEF` | theme file value |
| `yellow` | `#DCB258` | `#FDF7EC` | theme file value |

Invoice status/type colors appear inline in `searchBill/src/tracuuhoadon/quanlyhoadon/hoadon.component.html`:

- `#0747A6`
- `#34bfa3`
- `#bd2130`
- `#007bff`
- `#117a8b`
- `#FF9933`

## Typography

### frontend_angular Typography

Global font family is defined in `frontend_angular/src/assets/scss/_variables.scss` and applied in `frontend_angular/src/assets/scss/_overrides.scss`:

```css
Inter var, ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"
```

Existing text utilities in `frontend_angular/src/assets/scss/custom/_text.scss`:

| Class | Font Size | Line Height |
| --- | --- | --- |
| `.text-xs` | `12px` | `16px` |
| `.text-sm` | `14px` | `20px` |
| `.text-lg` | `18px` | `28px` |
| `.text-xl` | `20px` | `28px` |
| `.text-2xl` | `24px` | `32px` |

Generated text utilities exist in `frontend_angular/src/assets/scss/custom/_display_visible.scss`:

- `.text-fw-{weight}` from `$fontWeight`.
- `.font-size-{n}` in pixels from `$width`.

Poppins font files exist in `frontend_angular/src/assets/fonts/fonts-poppins.css`, but the active global family in `_variables.scss` is the Inter/system stack.

### searchBill Typography

Global typography in `searchBill/src/styles.css`:

```css
body { font-family: Arial, Helvetica, sans-serif !important; font-weight: normal !important; }
.btn { font-family: Arial, Helvetica, sans-serif !important; }
.primeng-datatable-container .ui-table table thead tr th { font-family: Arial, Helvetica, sans-serif !important; }
.m-form .form-control-label, .m-form label { font-family: Arial, Helvetica, sans-serif !important; }
```

Font files are included but not selected globally in `styles.css`:

- `searchBill/src/assets/fonts/fonts-roboto.css`: Roboto weights `300`, `400`, `500`, `700`.
- `searchBill/src/assets/fonts/fonts-poppins.css`: Poppins weights `300`, `400`, `500`, `600`, `700`.

Document/report modal typography in `searchBill/src/tracuuhoadon/thongtinchung/thongbaophathanh-modal.component.less`:

| Selector | Typeface | Size | Color |
| --- | --- | --- | --- |
| `#reported` | `Times New Roman`, `Times`, `serif` | `14px !important` | `#333` |
| `#reported h1` | inherited | `18px` | inherited |
| `#reported h2`-`h6` | inherited | mostly `16px` | inherited |

## Spacing

### frontend_angular Spacing

Utility spacing classes in `frontend_angular/src/assets/scss/custom/_spacing_cs.scss`:

- Margins: `.margin-left-5`, `.margin-right-5`, `.margin-top-5`, `.margin-top-15`, `.margin-top-20`, `.margin-bottom-5`, `.margin-bottom-10`, `.margin-bottom-15`.
- Padding: `.padding-left-5`, `.padding-right-5`, `.padding-top-5`, `.padding-bottom-5`.
- Column offsets: `.-margin-col`, `.ml-col`.
- Width percent utilities: `.width-percent-5` through `.width-percent-100`.

Gap utilities in `frontend_angular/src/assets/scss/custom/_display_visible.scss`:

| Class | Value |
| --- | --- |
| `.gap-1` | `0.25rem` |
| `.gap-2` | `0.5rem` |
| `.gap-3` | `1rem` |
| `.gap-4` | `1.5rem` |
| `.gap-5` | `3rem` |

Responsive width/height utilities are generated from mixins in `frontend_angular/src/assets/scss/custom/_mixin.scss`, including width, height, viewport width/height, min/max width, min/max height, percent width, and responsive variants.

### searchBill Spacing

Utility spacing in `searchBill/src/styles.css`:

- Margins: `.margin-left-5`, `.margin-right-5`, `.margin-top-5`, `.margin-top-15`, `.margin-bottom-5`, `.margin-bottom-15`.
- Padding: `.padding-left-5`, `.padding-right-5`, `.padding-top-5`, `.padding-bottom-5`.
- Width percent utilities: `.width-percent-5` through `.width-percent-100`.
- `.wid100` sets full width.

Additional utilities in `searchBill/src/app/shared/core.less`:

- `.margin-bottom-0`
- `.margin-top-20`
- `.margin-bottom-10`

Portlet/content spacing in `searchBill/src/styles.css`:

| Selector | Spacing |
| --- | --- |
| `.m-portlet .m-portlet__body` | `padding: 1rem 2rem !important` |
| `.m-portlet .m-portlet__head` | `height: 4rem !important` |
| `.m-portlet` | `margin-bottom: 0.5rem !important` |
| `.m-subheader` | `padding: 5px 0px 0 15px !important` |
| `.m-content` | `padding: 5px 15px !important` |

## Button Variants

### frontend_angular Buttons

Global button styling in `frontend_angular/src/assets/scss/_overrides.scss`:

```css
.btn + .btn { margin-left: 0.286rem; }
.btn { font-family: var(--font-family-sans-serif); padding: 0.571rem 0.75rem; font-weight: 500; }
.btn > i { vertical-align: baseline; }
```

Existing button variations:

| Selector / Class | Style | Source |
| --- | --- | --- |
| `.btn-phathanh .btn` | `padding: 0.154rem 0.231rem` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `.btn-tag` | `padding: 0.071em 0.571em` | `frontend_angular/src/assets/scss/_overrides.scss` |
| `.btn-warning` component override | `background-color: #8B6914; border-color: #8B6914; color: white` | `thongtinbangke.component.css` |
| Guide component `.btn` | `border: 2.5px solid #0786CD; color: #0786CD; background-color: #fff; font-size: 13px` | `huongdansudung.component.css` |

Bootstrap button classes such as `.btn-primary`, `.btn-secondary`, `.btn-info`, `.btn-warning`, `.btn-outline-success`, and `.btn-sm` are used in templates and inherit Bootstrap/Metronic styling plus project overrides.

### searchBill Buttons

Global button styling in `searchBill/src/styles.css` and `searchBill/src/app/shared/core.less`:

```css
.btn { font-family: Arial, Helvetica, sans-serif !important; }
.btn { border-radius: 0 !important; }
.btn + .btn { margin-left: 5px; }
button i { margin-right: 5px; }
.btn > i { vertical-align: baseline; margin-left: 5px; }
```

Observed button classes in templates:

- `.btn.btn-outline-success`
- `.btn.btn-primary`
- `.btn.btn-sm.btn-info`
- `.btn.btn-sm.btn-warning`
- `.btn.btn-sm.btn-primary`
- `.btn.btn-secondary`
- `.btn.btn-primary.m-btn.m-btn--pill.m-btn--custom.m-btn--air`

The search form button in `searchBill/src/tracuuhoadon/tracuu/tracuu.component.html` uses inline padding:

```css
padding: .75rem 2rem
```

## Input Styles

### frontend_angular Inputs

Global form controls in `frontend_angular/src/assets/scss/_overrides.scss`:

```css
.form-control:focus { border-color: var(--primary); }
.form-control[disabled] { height: auto; }
.form-control,
.bootstrap-select > .dropdown-toggle,
.col-form-label { padding: 0.571rem 0.75rem; }
```

Validation styles:

```css
.form-group.form-md-line-input.has-error .form-control { border-bottom-color: red; }
.form-control.ng-touched.ng-invalid { border-bottom-color: red; }
```

Invoice-style inputs in `frontend_angular/src/assets/scss/_overrides.scss`:

```css
.input-invoice input,
.input-invoice .ui-inputtext { border-bottom: 1px dashed var(--border-color); }
.input-invoice input:focus,
.input-invoice .ui-inputtext:focus { border-bottom-color: var(--primary); }
.input-invoice-cbb { border-bottom: 1px dashed #d4d4d4; }
```

Switch control in `frontend_angular/src/assets/scss/custom/_input.scss`:

- `.switch`
- `.slider`
- `.slider.round`
- Checked state uses `var(--primary)`.

Component example in `nhapvanban.component.css`:

```css
.textInput { border: none; border-bottom: thin dashed black; color: #333; }
```

### searchBill Inputs

Global input styles in `searchBill/src/styles.css`:

```css
.input-group .btn,
.form-control,
.col-form-label { border-radius: 0 !important; padding: 0.65rem 1rem !important; }
.old-form-control { border-radius: 0; padding: 0; }
.ui-inputtext { padding: .25em; font-weight: 400; }
.bootstrap-select.btn-group > .dropdown-toggle { border-radius: 0; }
.bootstrap-select.form-control { padding: 0; border-radius: 0; }
td .bootstrap-select button { padding: 0.65rem 1rem; border-radius: 0; }
```

Read-only input background in theme files:

```css
.form-control[readonly] { background-color: #f3f3f3 !important; }
```

Validation styles in `searchBill/src/app/shared/core.less`:

```css
.form-group.form-md-line-input.has-error .form-control { border-bottom-color: red; }
.form-group.form-md-line-input .form-control.ng-touched.ng-invalid { border-bottom-color: red; }
```

Representative form usage in `searchBill/src/tracuuhoadon/quanlyhoadon/hoadon.component.html`:

- Text inputs use `.form-control.m-input`.
- Selects use `.form-control`.
- Date inputs use `.form-control`.

PrimeNG autocomplete override in `searchBill/src/assets/primeng/autocomplete/css/primeng.autocomplete.less`:

```css
.ui-autocomplete-input-token { padding: 0px; }
.ui-autocomplete-multiple-container { width: 100%; }
```

## Table Styles

### frontend_angular Tables

Global table styles in `frontend_angular/src/assets/scss/_overrides.scss`:

```css
.table thead th { vertical-align: middle; }
tr.vs-row > th,
tr.vs-row > td { border-top: 1px solid var(--border-table-color); vertical-align: middle; }
.tbl-newinvoice td,
.tbl-newinvoice th { padding: 0.1rem; border: 1px solid var(--border-table-color); }
```

PrimeNG table overrides:

```css
.primeng-datatable-container .primeng-paging-container { padding-top: 0.5rem; padding-bottom: 0.5rem; }
.primeng-datatable-container .ui-table table thead tr th { font-family: var(--font-family-sans-serif); }
.ui-table.ui-widget.ui-table-responsive.ui-table-hoverable-rows { position: unset; }
.ui-table-wrapper { min-height: unset; }
```

Responsive invoice table in `frontend_angular/src/assets/scss/custom/_table.scss`:

- `table.table-add-invoice { width: 100%; table-layout: fixed; }`
- At `max-width: 992px`, the table hides `thead`, makes rows block-level, makes cells flex, and uses `td::before { content: attr(data-label); font-weight: 600; width: 20%; }`.

Component examples:

- `nhapvanban.component.css`: `.table-hoadon { width: 100%; border-collapse: collapse; }` with borders on table/td/th.
- `thongtinbangke.component.css`: `.invoice-table` uses `12px` text, collapsed borders, black borders, and `th` background `#d4c5a9`.

### searchBill Tables

PrimeNG datatable theme in `searchBill/src/assets/common/styles/themes/default/primeng.datatable.less`:

| Selector / State | Style |
| --- | --- |
| `.primeng-datatable-container td` | right border `#ececec` |
| Header cells | background `#e6e6e6 !important` |
| Highlighted header color | `#5867dd` |
| Even rows | `#f4f3fb` |
| Selected rows | background `#5867DD`, text `#fff` |
| Footer | border `#ececec`, background `#f5f5f5` |
| Paginator page link | `#5867dd` |
| Paginator active background | `#716aca` |
| Paginator hover background | `#deddf3` |

Global row styles in `searchBill/src/styles.css`:

```css
tr.vs-row > th { padding: .73em; border-top: 1px solid #f4f5f8; vertical-align: middle; }
tr.vs-row > td { border-top: 1px solid #f4f5f8; vertical-align: middle; }
```

Representative table usage in `searchBill/src/tracuuhoadon/quanlyhoadon/hoadon.component.html`:

- `.primeng-datatable-container` wrapper.
- `<p-table>` with lazy loading, scrolling, `scrollHeight="100%"`, and `[responsive]="primengTableHelper.isResponsive"`.
- `.primeng-paging-container` for paginator wrapper.

## Modal Styles

### frontend_angular Modals

Bootstrap modal overrides in `frontend_angular/src/assets/scss/_overrides.scss`:

```css
.modal .modal-content .modal-header { padding: 1rem; background: #038599; }
.modal-content { margin-top: 3.846rem; }
.modal { background-color: rgba(0, 0, 0, 0.5); }
.modal-confirm { max-width: 560px; }
```

Alert/SweetAlert styles in `frontend_angular/src/assets/scss/_overrides.scss`:

- `.alert-box`
- `.swal-title`
- `.swal-footer`
- `.swal-button`
- Confirm button color `#3085d6`.
- Cancel button color `#aaa`.
- `.swal2-title` and `.swal2-content` use `var(--text-color)`.

PDF modal component example in `danhsachbangke.component.css`:

| Selector | Style |
| --- | --- |
| `.pdf-modal-overlay` | `rgba(0,0,0,0.7)` overlay |
| `.pdf-modal-container` | border radius `12px`, shadow `0 20px 60px rgba(0,0,0,0.3)` |
| `.pdf-modal-header` | background `#038599 !important` |

### searchBill Modals

Global modal styling in `searchBill/src/styles.css`:

```css
.modal .modal-content .modal-header { padding: 1rem !important; }
```

Close icon cursor in `searchBill/src/assets/common/styles/metronic-customize.less`:

```css
.modal .modal-content .modal-header .close:before { cursor: pointer !important; }
```

Observed modal structure in templates:

- `.modal.fade`
- `.modal-dialog.modal-lg`
- `.modal-content`
- `.modal-header`
- `.modal-body`
- `.modal-footer`

Representative inline modal patterns:

- `popup-modal.component.html`: modal content uses `margin: 0.75rem auto` and `width: fit-content`.
- `xem-hoadon-modal.component.html`: dialog uses `margin: 3.75rem auto`, `transform: scale(0.8)`, `width: fit-content`.
- PDF/image modals use max/content widths such as `850px` and `950px` in `vanbanthoathuan-xem-modal.component.html` and `thongbaophathanh-modal.component.html`.

## Icons

### frontend_angular Icons

Imported icon libraries in `frontend_angular/src/assets/scss/_base.scss`:

- Bootstrap Icons.
- Font Awesome.
- PrimeIcons.
- Line Awesome.
- Flaticon.
- Metronic icon CSS.

Existing icon adjustments:

```css
.page-sidebar .page-sidebar-menu > li > a > i.fa { ... }
.btn > i { vertical-align: baseline; }
```

PrimeNG paginator icons are remapped in `frontend_angular/src/assets/scss/_overrides.scss` through selectors such as:

- `.ui-paginator-first .ui-paginator-icon::before`
- `.ui-paginator-last .ui-paginator-icon::before`
- `.ui-paginator-prev .ui-paginator-icon::before`
- `.ui-paginator-next .ui-paginator-icon::before`

Metronic icon font definitions exist in `frontend_angular/src/assets/metronic/src/vendors/metronic/css/styles.css` through `.icons8` and `[data-icons8]:before` selectors.

### searchBill Icons

Imported icon CSS in `searchBill/angular.json`:

- Font Awesome.
- PrimeIcons.
- Line Awesome.
- Flaticon.

Representative icon usage:

| Context | Classes |
| --- | --- |
| Top menu | `flaticon-search`, `flaticon-list-2`, `flaticon-list`, `fa fa-sign-in` |
| Invoice list actions | `fa fa-file-excel-o`, `fa fa-angle-down`, `fa fa-angle-up`, `flaticon-search`, `fa fa-ellipsis-h`, `fa fa-download` |
| Modal actions | `fa fa-download`, `fa fa-print`, `fa fa-eye` |

Icon spacing:

```css
button i { margin-right: 5px; }
.btn > i { vertical-align: baseline; margin-left: 5px; }
```

## Layout

### frontend_angular Layout

Global layout and page structure come from Metronic plus project overrides.

Observed layout rules:

| Selector / Context | Style |
| --- | --- |
| `body` | background `#f8f8f8` |
| `.page-header.navbar .top-menu .navbar-nav > li.dropdown-dark .dropdown-menu` | width `19.231rem` |
| `.page-header.navbar .page-logo .logo-default` | customized in `_overrides.scss` |
| Fixed/static header | `z-index: 1000` |
| `.logoMobile` | `display: none` by default |
| `.menuMobile` | `display: flex`, shadow `0 0 4px rgba(0,0,0,.25)`, padding `0 1.923rem`, `justify-content: space-between` |
| `.sticky-bottom` | `position: sticky; bottom: 0; z-index: 100` |
| `.fixed-bottom` | `position: static` |
| `.padding-col` | left/right padding `15px` |

Layout utility examples in `frontend_angular/src/assets/scss/_overrides.scss`:

- `.col-lg-4 { flex: none; }`
- `.div-10`
- `.div-25`
- `.div-40`
- `.div-75`

Responsive display/overflow/flex utilities are generated in `frontend_angular/src/assets/scss/custom/_display_visible.scss` and `frontend_angular/src/assets/scss/custom/_mixin.scss`.

### searchBill Layout

App root layout in `searchBill/src/assets/common/styles/metronic-customize-angular.less`:

```css
app-root { display: flex; flex: 1; flex-direction: column; }
```

Layout classes are generated by `searchBill/src/shared/common/ui/app-ui-customization.service.ts`:

- Body classes include `m-page--{LayoutType}`, `m--skin-{ContentSkin}`, `m-header--fixed/static`, aside fixed/minimized/hidden/skin/offcanvas classes, and fixed footer class.
- Container class is `m-container--responsive` for boxed layout and `m-container--fluid` otherwise.
- Top menu uses `m-container m-container--responsive m-container--full-height m-page__container`, with `m-container--xxl` added for boxed layout.

Search-bill screen layout:

- `searchBill/src/tracuuhoadon/tracuuhoadon.component.html` uses `<top-bar-menu>` and `<router-outlet>`.
- Search forms use Metronic grid/login classes such as `.m-grid__item`, `.m-grid`, `.m-login`, `.m-login__aside`, `.m-stack`, `.m-login__wrapper`.
- List pages use `.m-subheader`, `.m-content`, `.m-portlet.m-portlet--mobile`, `.m-portlet__body`, `.row`, `.form-group`, `.m-form__group`, and `.col-md-*`.

Specific login/search layout values in `searchBill/src/styles.css`:

```css
.m-login.m-login--1 .m-login__aside { width: 405px !important; margin: 4% auto; padding: 2rem; }
.m-login.m-login--1 .m-login__wrapper { padding: 2rem 2rem 0rem 2rem; background: #cccc; border-radius: 25px; }
```

## Responsive Rules

### frontend_angular Responsive Rules

Breakpoints in `frontend_angular/src/assets/scss/_variables.scss`:

| Token | Value |
| --- | --- |
| `$xs` | `0px` |
| `$sm` | `576px` |
| `$md` | `768px` |
| `$lg` | `992px` |
| `$xl` | `1200px` |
| `$xxl` | `1440px` |

Responsive rules in `frontend_angular/src/assets/scss/custom/_responsive.scss`:

| Media Query | Behavior |
| --- | --- |
| `max-width: 450px` | hide `.tenancy-name`, hide `.m-menu__link-text.langname` |
| `max-device-width: 640px` | hide `.edition-info-text` |
| `min-width: 992px` | `#m_header_nav { height: auto }` |
| `max-width: 1024px` | show `.logoMobile`, adjust `li.dropdown-language a` |
| `min-width: 1200px` | `.modal-xl { max-width: 1140px }` |
| `min-width: 1400px` | boxed `.subscription-info` width `103.077rem` |
| `min-width: 1440px` and `1920px` | `.m-login__aside2 { top: 15% }` |

Table-specific responsive behavior in `frontend_angular/src/assets/scss/custom/_table.scss`:

- At `max-width: 992px`, `.table-add-invoice` becomes stacked/mobile row layout.

PDF modal responsive behavior in `danhsachbangke.component.css`:

- At `max-width: 768px`, `.pdf-modal-container` uses `width: 95%` and `height: 95vh`, with smaller header padding and title font.

### searchBill Responsive Rules

Theme/mobile menu breakpoint in theme files such as `searchBill/src/assets/common/styles/themes/default/metronic-customize.less`:

- `@media(max-width: 992px)` sets mobile active menu background, hover background, and active colors.

Top menu desktop breakpoint in `searchBill/src/assets/common/styles/themes/default/metronic-customize-top-menu.less`:

- `@media (min-width: 993px)` controls top menu background behavior.

Layout responsive rules in `searchBill/src/app/shared/layout/layout.less`:

| Media Query | Behavior |
| --- | --- |
| `max-device-width: 640px` | `.edition-info-text { display: none; }` |
| `max-width: 992px` | language dropdown padding changes |
| `min-width: 993px` | `#m_header_nav { height: auto !important; }` |
| `max-width: 450px` | hide `.tenancy-name`, hide `.m-menu__link-text.langname`, adjust flag margin |
| `min-width: 1400px` | boxed `.subscription-info` width `1340px`, centered |

PrimeNG table responsive mode is enabled in `searchBill/src/tracuuhoadon/quanlyhoadon/hoadon.component.html`:

```html
<p-table [responsive]="primengTableHelper.isResponsive">
```

## Existing Theme and Library Dependencies

The frontend design system is built on existing third-party libraries and local overrides.

| Library | Projects | Existing Purpose |
| --- | --- | --- |
| Bootstrap 4 | `frontend_angular`, `searchBill` | Core layout and components such as buttons, modals, dropdowns, forms. |
| Bootstrap plugins | `frontend_angular`, `searchBill` | Selects, switches, date ranges, time picker, touchspin, markdown, notifications, hover dropdowns, datetime picker. |
| Bootstrap Icons | `frontend_angular` | Bootstrap icon font/classes. |
| Metronic | `frontend_angular`, `searchBill` | Admin layout, menus, header, sidebar, portlet, offcanvas, theme behavior. |
| PrimeNG | `frontend_angular`, `searchBill` | Angular UI components, especially datatable/table, paginator, checkbox, file upload, autocomplete. |
| PrimeIcons | `frontend_angular`, `searchBill` | PrimeNG icon classes. |
| Font Awesome 4 | `frontend_angular`, `searchBill` | Icon classes used across menus, actions, buttons. |
| Line Awesome | `frontend_angular`, `searchBill` | Metronic icon dependency. |
| Flaticon | `frontend_angular`, `searchBill` | Metronic icon dependency and menu/action icons. |
| Poppins | `frontend_angular`, `searchBill` | Local font files; included in searchBill global styles. |
| Roboto | `searchBill`; frontend_angular font files exist | Local font files in searchBill; frontend_angular has Roboto font files but no `fonts-roboto.css` entry was found in the reviewed frontend_angular style entry. |

## Notes on Existing System

- `frontend_angular` and `searchBill` share Metronic, Bootstrap, PrimeNG, Font Awesome, Line Awesome, and Flaticon foundations.
- `frontend_angular` centralizes styles through SCSS imports under `frontend_angular/src/assets/scss/`.
- `searchBill` loads more styles directly from `angular.json` and `src/styles.css`.
- Both projects contain component-level CSS/LESS overrides for specific screens and modals.
- This document intentionally avoids defining new design tokens beyond values already present in the reviewed source.
