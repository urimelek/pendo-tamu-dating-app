import React from 'react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Heart, Users, MessageCircle, Star, Shield, Zap } from 'lucide-react';

function Landing() {
  const features = [
    {
      icon: <Heart size={48} style={{ color: '#ff6b6b' }} />,
      title: 'Smart Matching',
      description: 'AI-powered compatibility algorithm finds your perfect match'
    },
    {
      icon: <Users size={48} style={{ color: '#feca57' }} />,
      title: 'Local Community',
      description: 'Connect with amazing people in your area and beyond'
    },
    {
      icon: <MessageCircle size={48} style={{ color: '#48dbfb' }} />,
      title: 'Real-time Chat',
      description: 'Instant messaging with matches, share photos and voice notes'
    },
    {
      icon: <Star size={48} style={{ color: '#ff9ff3' }} />,
      title: 'Premium Features',
      description: 'Super likes, boost your profile, and see who liked you'
    },
    {
      icon: <Shield size={48} style={{ color: '#54a0ff' }} />,
      title: 'Safe & Secure',
      description: 'Photo verification, reporting system, and privacy controls'
    },
    {
      icon: <Zap size={48} style={{ color: '#5f27cd' }} />,
      title: 'Fast & Fun',
      description: 'Smooth swiping experience with engaging animations'
    }
  ];

  return (
    <div className="landing">
      <motion.div
        initial={{ opacity: 0, y: 50 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8 }}
      >
        <h1>Pendo Tamu</h1>
        <p>Find your perfect match in the heart of Africa 💕</p>
        
        <div className="features" style={{ 
          margin: '4rem 0', 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', 
          gap: '2rem', 
          maxWidth: '1200px' 
        }}>
          {features.map((feature, index) => (
            <motion.div 
              key={index}
              className="feature"
              whileHover={{ scale: 1.05 }}
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              style={{ 
                textAlign: 'center', 
                padding: '2rem',
                background: 'rgba(255, 255, 255, 0.1)',
                borderRadius: '20px',
                backdropFilter: 'blur(10px)',
                border: '1px solid rgba(255, 255, 255, 0.2)'
              }}
            >
              <div style={{ marginBottom: '1rem' }}>
                {feature.icon}
              </div>
              <h3 style={{ marginBottom: '1rem', fontSize: '1.3rem' }}>
                {feature.title}
              </h3>
              <p style={{ opacity: 0.9, lineHeight: '1.5' }}>
                {feature.description}
              </p>
            </motion.div>
          ))}
        </div>
        
        <motion.div 
          className="cta-buttons"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.5 }}
        >
          <Link to="/register" className="btn btn-primary">
            Start Your Journey
          </Link>
          <Link to="/login" className="btn btn-secondary">
            Welcome Back
          </Link>
        </motion.div>
        
        <motion.div 
          style={{ 
            marginTop: '4rem', 
            textAlign: 'center',
            opacity: 0.8 
          }}
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.8 }}
          transition={{ duration: 1, delay: 1 }}
        >
          <p style={{ fontSize: '1rem', marginBottom: '1rem' }}>
            Join thousands of people finding love across Africa
          </p>
          <div style={{ 
            display: 'flex', 
            justifyContent: 'center', 
            gap: '2rem',
            flexWrap: 'wrap',
            fontSize: '0.9rem'
          }}>
            <span>🇳🇬 Nigeria</span>
            <span>🇰🇪 Kenya</span>
            <span>🇿🇦 South Africa</span>
            <span>🇬🇭 Ghana</span>
            <span>🇪🇹 Ethiopia</span>
            <span>🇺🇬 Uganda</span>
          </div>
        </motion.div>
      </motion.div>
    </div>
  );
}

export default Landing;