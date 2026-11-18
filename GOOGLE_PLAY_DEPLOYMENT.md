# دليل رفع تطبيق دلتا (Delta) على متجر Google Play

تم إعداد وتجهيز كافة المتطلبات التقنية الخاصة برفع التطبيق على متجر **Google Play Console**.

---

## 1. بيانات الحزمة والتطبيق (App & Package Info)
- **اسم التطبيق (App Name):** `Delta`
- **معرف التطبيق الفريد (Application ID / Package Name):** `com.asgsystems.delta`
- **إصدار التطبيق الحالي (Version Name):** `1.5.0`
- **رقم البناء (Version Code):** `7`
- **Compile SDK:** `36` (Android 16 / أحدث مكتبات AndroidX)
- **Target SDK:** `36` (متوافق مع أحدث متطلبات Google Play)
- **Min SDK:** `21` (Android 5.0 Lollipop فما فوق)

---

## 2. مفتاح التوقيع الرقمي (Release Keystore & Signing)
تم إنشاء وتوليد مفتاح التوقيع الرقمي الرسمي (PKCS12) وربطه في ملف `android/key.properties`:

- **مسار المفتاح (Keystore Path):** `android/app/upload-keystore.jks`
- **اسم المعرف (Alias):** `delta_upload`
- **كلمة مرور المفتاح (Key Password):** `DeltaASG2026@Secure`
- **كلمة مرور المتجر (Store Password):** `DeltaASG2026@Secure`
- **الصلاحية:** صالحة حتى عام **2054** (10,000 يوم)
- **بصمات الشهادة (Fingerprints):**
  - **SHA-1:** `D5:97:08:F7:0B:32:CB:70:FA:D0:EF:C3:41:5E:AE:64:80:51:9E:9E`
  - **SHA-256:** `0C:A4:75:A9:11:4D:2A:AF:26:0C:2C:A4:39:3E:7C:45:A9:81:0A:61:86:41:A6:20:28:67:D5:8F:A4:F6:69:24`

> ⚠️ **ملاحظة أمان هامة جداً:**
> احتفظ بنسخة احتياطية من ملف `android/app/upload-keystore.jks` وملف `android/key.properties` في مكان آمن وخارجي (مثل Google Drive أو 1Password). إذا فُقد هذا المفتاح، فلن تتمكن من تحديث التطبيق على Google Play لنفس الـ Application ID.

---

## 3. الصلاحيات المُعدّة في `AndroidManifest.xml`
تم تفعيل الصلاحيات التالية في بيئة الإنتاج:
- `INTERNET`: للاتصال بخوادم وخدمات الـ ERP وسحب التقارير.
- `ACCESS_NETWORK_STATE`: للتحقق من حالة اتصال الإنترنت والعمل في وضع عدم الاتصال (Offline).
- `CAMERA`: لمسح الباركود والفواتير والمستندات بـ OCR.
- `READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE`: لرفع واختيار صور المستندات.
- `usesCleartextTraffic="true"`: لضمان دعم الاتصال بالخوادم والـ endpoints التي تستخدم منافذ أو بروتوكولات مخصصة.

---

## 4. أمر بناء الحزمة لـ Google Play (Build App Bundle)
متجر Google Play يطلب صيغة **AAB (Android App Bundle)** وليس APK عادي.

لبناء النسخة الجاهزة للرفع مباشرة، شغّل الأمر التالي في الطرفية (Terminal):

```bash
flutter build appbundle --release
```

بعد اكتمال البناء، ستجد الملف جاهزاً للرفع في هذا المسار:
```text
build/app/outputs/bundle/release/app-release.aab
```

*(إذا أردت أيضاً استخراج APK للتجربة على جهازك مباشرة قبل الرفع):*
```bash
flutter build apk --release
```
ومسار الملف سيكون:
```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 5. خطوات الرفع على Google Play Console
1. افتح [Google Play Console](https://play.google.com/console).
2. اضغط على **Create app** (إنشاء تطبيق).
3. اكتب اسم التطبيق: `Delta`، واختر اللغة الافتراضية، ونوع التطبيق (Free / Paid).
4. اذهب إلى **Release** > **Production** (أو **Internal testing** للتجربة أولاً).
5. اضغط **Create new release** وارفع ملف `app-release.aab`.
6. أكمل بيانات قائمة المتجر (Store Listing):
   - **Short description** (الوصف القصير)
   - **Full description** (الوصف الكامل)
   - **App icon** (أيقونة التطبيق 512x512 PNG)
   - **Feature graphic** (صورة الغلاف 1024x500)
   - **Phone Screenshots** (لقطات شاشة للتطبيق لا تقل عن صورتين)
7. أكمل إقرارات محتوى التطبيق (Policy & App Content):
   - سياسة الخصوصية (Privacy Policy URL).
   - إقرار الأمان والبيانات (Data Safety).
   - الفئة العمرية (Target Audience).
8. اضغط **Review and rollout release** لإرسال التطبيق للمراجعة.
