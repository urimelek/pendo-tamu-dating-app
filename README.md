# 💕 Pendo Tamu - Dating Platform

> **Pendo Tamu** means "Sweet Love" in Swahili - Find your perfect match in the heart of Africa!

A modern, full-featured dating application built with React and Supabase, designed specifically for connecting hearts across Africa and beyond.

![Pendo Tamu Banner](https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=1200&h=400&fit=crop)

## 🌟 Features

### 💖 Core Dating Features
- **Smart Matching Algorithm** - AI-powered compatibility matching
- **Swipe-based Discovery** - Intuitive Tinder-style interface
- **Real-time Chat** - Instant messaging with matches
- **Photo Sharing** - Share moments with your matches
- **Super Likes** - Show extra interest in someone special
- **Match Notifications** - Never miss a connection

### 🛡️ Safety & Security
- **Photo Verification** - Verified profiles for authentic connections
- **Report System** - Community-driven safety measures
- **Privacy Controls** - Control who sees your profile
- **Block & Unmatch** - Full control over your connections

### 🎯 Advanced Features
- **Location-based Matching** - Find people nearby
- **Age & Distance Filters** - Customize your preferences
- **Premium Subscriptions** - Enhanced features for serious daters
- **Profile Boost** - Increase your visibility
- **Read Receipts** - Know when messages are seen

## 🚀 Live Demo

**🌐 Website:** [https://pendo-tamu-dating-app.vercel.app](https://pendo-tamu-dating-app.vercel.app)

**📱 Mobile App:** Coming Soon on iOS & Android

## 🛠️ Tech Stack

### Frontend
- **React 18** - Modern React with Hooks
- **React Router** - Client-side routing
- **Framer Motion** - Smooth animations
- **Lucide React** - Beautiful icons
- **React Hot Toast** - Elegant notifications

### Backend & Database
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Robust relational database
- **Row Level Security** - Database-level security
- **Real-time Subscriptions** - Live updates

### Deployment & Hosting
- **Vercel** - Frontend deployment
- **Supabase Cloud** - Backend hosting
- **GitHub Actions** - CI/CD pipeline

## 📦 Installation & Setup

### Prerequisites
- Node.js 16+ and npm
- Supabase account
- Git

### 1. Clone the Repository
```bash
git clone https://github.com/urimelek/pendo-tamu-dating-app.git
cd pendo-tamu-dating-app
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Settings > API to get your keys
3. Run the database schema from `database/schema.sql`

### 4. Environment Variables

Create a `.env` file in the root directory:

```env
REACT_APP_SUPABASE_URL=your_supabase_project_url
REACT_APP_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 5. Start Development Server
```bash
npm start
```

Visit `http://localhost:3000` to see the app running!

## 🗄️ Database Schema

The application uses the following main tables:

### 👤 profiles
User profile information including preferences and settings.

### 💫 swipes
Records of user swipe actions (like, pass, super-like).

### 💕 matches
Mutual likes that create matches between users.

### 💬 messages
Chat messages between matched users.

### 🔔 notifications
System and user notifications.

### 💳 subscriptions
Premium subscription management.

See `database/schema.sql` for the complete schema with relationships and security policies.

## 🎨 Design System

### Color Palette
- **Primary Gradient:** `#667eea` → `#764ba2`
- **Love Red:** `#ff6b6b`
- **Sunshine Yellow:** `#feca57`
- **Ocean Blue:** `#48dbfb`
- **Soft Pink:** `#ff9ff3`

### Typography
- **Font Family:** Inter (Google Fonts)
- **Weights:** 300, 400, 500, 600, 700

## 📱 Mobile Responsiveness

Pendo Tamu is fully responsive and works seamlessly on:
- 📱 Mobile phones (iOS & Android)
- 📱 Tablets
- 💻 Desktop computers
- 🖥️ Large screens

## 🔐 Security Features

- **Row Level Security (RLS)** - Database-level access control
- **JWT Authentication** - Secure user sessions
- **Input Validation** - Prevent malicious data
- **HTTPS Only** - Encrypted connections
- **Privacy Controls** - User data protection

## 🚀 Deployment

### Deploy to Vercel (Recommended)

1. Fork this repository
2. Connect your GitHub account to Vercel
3. Import the project
4. Add environment variables
5. Deploy!

### Deploy to Netlify

1. Build the project: `npm run build`
2. Upload the `build` folder to Netlify
3. Configure environment variables
4. Set up redirects for SPA routing

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow React best practices
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📈 Roadmap

### Phase 1: Core Features ✅
- [x] User authentication & profiles
- [x] Swipe-based matching
- [x] Real-time chat
- [x] Basic notifications

### Phase 2: Enhanced Experience 🚧
- [ ] Mobile app (React Native)
- [ ] Push notifications
- [ ] Video chat integration
- [ ] Advanced matching algorithms
- [ ] Photo verification system

### Phase 3: Premium Features 📋
- [ ] Subscription management
- [ ] Profile boost & super likes
- [ ] Advanced filters
- [ ] Travel mode
- [ ] Events & meetups

### Phase 4: AI & Analytics 🔮
- [ ] AI-powered recommendations
- [ ] Personality matching
- [ ] Success rate analytics
- [ ] Dating insights

## 📊 Analytics & Metrics

Track key metrics:
- **User Engagement:** Daily/Monthly active users
- **Match Success:** Swipe-to-match conversion
- **Chat Activity:** Message frequency and response rates
- **Retention:** User return rates

## 🌍 Localization

Currently supporting:
- 🇺🇸 English (Primary)

Planned languages:
- 🇫🇷 French
- 🇵🇹 Portuguese
- العربية Arabic
- 🇪🇸 Spanish

## 📞 Support & Community

- **Email:** support@pendotamu.com
- **Discord:** [Join our community](https://discord.gg/pendotamu)
- **Twitter:** [@PendoTamu](https://twitter.com/pendotamu)
- **Instagram:** [@pendo.tamu](https://instagram.com/pendo.tamu)

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Supabase** - Amazing backend platform
- **Vercel** - Seamless deployment
- **Unsplash** - Beautiful stock photos
- **Lucide** - Clean, consistent icons
- **Framer Motion** - Smooth animations

## 💝 Made with Love

Built with ❤️ for the African diaspora and beyond. Connecting hearts, one swipe at a time.

---

**Pendo Tamu** - Where love stories begin 💕

[⭐ Star this repo](https://github.com/urimelek/pendo-tamu-dating-app) if you found it helpful!