# patient

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### How to setup

# Google Cloud Console Configuration

1. Go to the [Google Cloud Console](https://console.cloud.google.com/) and create a new project or select an existing one.
2. Navigate to **"APIs & Services" > "Credentials"**.
3. Click **"Create Credentials"** and select **"OAuth client ID"**.
4. Choose **"Web application"** as the application type.
5. Add your Supabase project's domain (`<PROJECT_ID>.supabase.co`) to the **"Authorized domains"** list.
6. Set the following authorized redirect URI: 
7. After creation, note down the **Client ID** and **Client Secret**.

Setting Up the Cloud Console for OAuth

![image](https://github.com/user-attachments/assets/ba9f4927-4e5e-4a68-b1d3-a0a273a8713a)


---

# Supabase Configuration

1. In your [Supabase project dashboard](https://app.supabase.io/), go to **"Authentication" > "Providers"**.
2. Find the **Google** section and enable **"Sign in with Google"**.
3. Enter the **Client ID** and **Client Secret** obtained from Google Cloud Console.
4. In **"Authentication" > "URL Configuration"**, set the **Site URL** and any additional redirect URLs for your application.