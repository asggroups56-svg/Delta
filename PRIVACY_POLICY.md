# Privacy Policy for Delta ERP Mobile Application

**Last updated:** November 17, 2026  
**Effective date:** November 17, 2026  

**Delta** ("the Application") is an enterprise resource planning (ERP) mobile software suite developed and published by **ASG Systems** ("we", "us", or "our"), available under the package name `com.asgsystems.delta`. 

This Privacy Policy informs users of our policies regarding the collection, use, disclosure, and protection of personal and enterprise information when using our Application, in compliance with the **Google Play Developer Program Policies**, **General Data Protection Regulation (GDPR)**, and applicable data protection regulations.

---

## 1. Information We Collect

### A. Information You Provide Directly
* **Account & Authentication Information:** When you log in to the Application, you provide your enterprise username, password, and enterprise connection credentials. These credentials are transmitted over encrypted TLS/SSL connections to authenticate with your organization's ERP server.
* **Business & Financial Data:** Depending on your enterprise role, you may submit or query financial transactions, invoices, journal entries, ledger accounts, reports, cost centers, and tax details.
* **Uploaded Images & Documents:** When utilizing the document attachment or OCR scanner features, you provide images of receipts, invoices, or business documents captured via your device's camera or selected from your photo library.

### B. Automatically Collected Information & Technical Data
* **Network & Connection Status:** The Application checks internet connectivity to handle offline data synchronization and display appropriate network state alerts.
* **Device & Diagnostic Data:** Basic diagnostic logs (such as network response status codes and crash logs) may be processed in-app to diagnose network timeouts or communication failures with the backend.

---

## 2. Device Permissions and How They Are Used

The Application requests the following runtime and declared permissions solely to deliver specific business functionalities:

| Permission | Purpose | Data Handling |
| :--- | :--- | :--- |
| **`CAMERA`** | Required to photograph invoices, paper vouchers, and business receipts for digitizing and optical character recognition (OCR). | Photos are processed locally on the device or uploaded solely to your organization's ERP system. Photos are never shared with unauthorized third parties. |
| **`READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE`** | Required to allow you to select previously captured images or PDF documents from your gallery to attach to invoices or transactions. | Only files explicitly selected by the user are accessed. |
| **`INTERNET`** | Required to establish secure, encrypted communication (HTTPS/TLS) with your organization's Delta ERP backend servers. | All transmitted enterprise and user data is encrypted in transit using industry-standard protocols. |
| **`ACCESS_NETWORK_STATE`** | Required to detect if the device has an active network connection, switching gracefully between online processing and offline caching. | No personal data is collected from this permission. |

---

## 3. On-Device Processing & Machine Learning (OCR)

The Application uses **Google ML Kit Text Recognition** to extract text from scanned invoices and receipts:
* Text extraction and optical recognition are performed **locally on your device**.
* Extracted document text is placed into editable form fields for user review before saving.
* Images and text processed by the OCR engine are not sent to any external advertising or tracking platforms.

---

## 4. How We Use Your Information

We process and use collected data strictly for legitimate enterprise business purposes:
* Authenticating authorized enterprise users.
* Generating, managing, and displaying financial reports, charts, and accounting ledgers.
* Generating and exporting PDF and Excel reports saved locally to your device's download directory at your direction.
* Maintaining system integrity, data safety, and preventing unauthorized access.

---

## 5. Data Sharing and Third-Party Disclosure

**We do not sell, rent, monetize, or trade any personal or enterprise data to third-party data brokers, marketers, or advertisers.**

Data is only transmitted to:
* **Your Organization's Designated ERP Server:** Communication is conducted via secure HTTPS endpoints configured by your enterprise.
* **Essential Cloud Infrastructure Services:** Secure hosting and database infrastructure operated on behalf of ASG Systems and your enterprise to deliver the core ERP services.
* **Legal Requirements:** If required by applicable law, regulation, or enforceable governmental request.

---

## 6. Data Security and Retention

* **Encryption in Transit:** All communication between the Application and backend servers is encrypted using Transport Layer Security (TLS/HTTPS).
* **Local Storage & Caching:** Sensitive session tokens and user preferences are securely stored on the device using isolated application storage.
* **Data Retention:** Personal and business records are retained according to your organization's enterprise data retention policies and contractual agreements with ASG Systems.

---

## 7. User Rights and Data Deletion

In accordance with international privacy laws:
* You have the right to access, inspect, correct, or request the deletion of your account and associated personal data.
* As Delta is an enterprise ERP system managed by your employer or organization, requests to delete or modify business accounts should be submitted to your organization's system administrator or by contacting us at our support channels below.

---

## 8. Children's Privacy

The Application is designed exclusively for business and workplace management. It is not intended for or marketed to individuals under the age of 18 (or the legal age of majority in your jurisdiction). We do not knowingly collect personal information from children.

---

## 9. Changes to This Privacy Policy

We may update this Privacy Policy from time to time to reflect changes in our practices or applicable legal requirements. The updated policy will be posted on this page with an updated "Last updated" date. Continued use of the Application signifies acceptance of the revised policy.

---

## 10. Contact Us

If you have any questions, concerns, or inquiries regarding this Privacy Policy or our privacy practices, please contact us at:

* **Company:** ASG Systems (Applied Systems Group)
* **Application:** Delta ERP Mobile
* **Email:** support@asg-systems.com
* **Website:** https://delta-icloud.com
* **Address:** Riyadh, Kingdom of Saudi Arabia
