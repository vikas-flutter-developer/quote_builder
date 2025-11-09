# 🧾 Quote Builder

A modern **Flutter-based quotation generator** that helps businesses create, calculate, and export professional product quotes with ease.  
Designed with clean UI, real-time calculations, and PDF export capabilities — all powered by **Flutter & BLoC**.

---

## 📖 Overview

**Quote Builder** is a B2B-focused Flutter application that enables users to generate detailed product or service quotations.  
The app provides a dynamic form for client details and line items, performs instant total calculations, and generates a professional, shareable PDF preview.

---

## ✨ Key Features

### 🧍 Client Information
- Capture **Client Name**, **Address**, and **Reference Number**
- Instantly visible in the generated PDF

### 📦 Dynamic Product Line Items
- Add unlimited line items dynamically  
- Each item includes:
  - Product/Service Name  
  - Quantity  
  - Rate  
  - Discount (optional)  
  - Tax %  

### 🔢 Real-Time Calculations
- Automatic subtotal and grand total updates  
- Formula:  
- Accurate tax and discount calculations per item

### 🧾 Quote Preview
- Professional PDF preview layout  
- Uses the `pdf` and `printing` packages  
- Displays company logo, client info, and line-item table  

### 💾 File & Share Integration
- Save quote as PDF using `file_saver`
- Instantly share quotes via email, WhatsApp, or any sharing app with `share_plus`

### 💰 Currency & Text Conversion
- Uses `intl` for locale-aware currency formatting  
- Converts totals to words with `number_to_words_english`

### 🎨 UI & Branding
- Clean, business-grade UI  
- Custom `Hind` fonts for elegant typography  
- Includes company **logo** and **signature**

### 🧩 State Management
- Built using **Flutter BLoC Architecture**
- Clean separation of UI, Logic, and Data Layers

---

## 🧠 Tech Stack

| Package | Description |
|----------|--------------|
| `flutter_bloc` | Reactive state management |
| `equatable` | Simplifies state comparison |
| `intl` | Currency & date formatting |
| `uuid` | Unique identifier for each quote |
| `pdf`, `printing` | PDF generation and preview |
| `google_fonts` | Font management |
| `file_saver` | Save generated PDF locally |
| `share_plus` | Share PDFs easily |
| `number_to_words_english` | Converts total numbers to words |

---

🧑‍💻 Developer

👤 Vikas Salvi
💼 Flutter Developer
🔗 GitHub: [Vikas-Android-Developer](https://github.com/vikas-flutter-developer?tab=repositories)

