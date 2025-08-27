-- Pendo Tamu Database Schema
-- Run this in your Supabase SQL editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  age INTEGER CHECK (age >= 18 AND age <= 100),
  gender TEXT CHECK (gender IN ('male', 'female', 'non-binary', 'other')),
  location TEXT NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  interests TEXT[],
  looking_for TEXT CHECK (looking_for IN ('male', 'female', 'non-binary', 'everyone')),
  max_distance INTEGER DEFAULT 50,
  min_age INTEGER DEFAULT 18,
  max_age INTEGER DEFAULT 100,
  is_premium BOOLEAN DEFAULT FALSE,
  is_verified BOOLEAN DEFAULT FALSE,
  last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (id)
);

-- Create swipes table
CREATE TABLE swipes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  swiper_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  swiped_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  action TEXT CHECK (action IN ('like', 'pass', 'super-like')) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(swiper_id, swiped_id)
);

-- Create matches table
CREATE TABLE matches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  profile1_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  profile2_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE,
  UNIQUE(profile1_id, profile2_id)
);

-- Create messages table
CREATE TABLE messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  match_id UUID REFERENCES matches(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'gif')),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create reports table
CREATE TABLE reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  reporter_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  reported_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create subscriptions table for premium features
CREATE TABLE subscriptions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  plan_type TEXT CHECK (plan_type IN ('premium', 'gold', 'platinum')),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'cancelled', 'expired')),
  starts_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  ends_at TIMESTAMP WITH TIME ZONE,
  stripe_subscription_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create notifications table
CREATE TABLE notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('match', 'message', 'like', 'super-like', 'system')),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  data JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view all profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Swipes policies
CREATE POLICY "Users can view own swipes" ON swipes FOR SELECT USING (auth.uid() = swiper_id);
CREATE POLICY "Users can insert own swipes" ON swipes FOR INSERT WITH CHECK (auth.uid() = swiper_id);

-- Matches policies
CREATE POLICY "Users can view own matches" ON matches FOR SELECT USING (auth.uid() = profile1_id OR auth.uid() = profile2_id);
CREATE POLICY "System can insert matches" ON matches FOR INSERT WITH CHECK (true);

-- Messages policies
CREATE POLICY "Users can view messages in their matches" ON messages FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM matches 
    WHERE matches.id = messages.match_id 
    AND (matches.profile1_id = auth.uid() OR matches.profile2_id = auth.uid())
  )
);
CREATE POLICY "Users can send messages in their matches" ON messages FOR INSERT WITH CHECK (
  auth.uid() = sender_id AND
  EXISTS (
    SELECT 1 FROM matches 
    WHERE matches.id = messages.match_id 
    AND (matches.profile1_id = auth.uid() OR matches.profile2_id = auth.uid())
  )
);

-- Reports policies
CREATE POLICY "Users can create reports" ON reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);
CREATE POLICY "Users can view own reports" ON reports FOR SELECT USING (auth.uid() = reporter_id);

-- Subscriptions policies
CREATE POLICY "Users can view own subscriptions" ON subscriptions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own subscriptions" ON subscriptions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- Functions and Triggers

-- Function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, first_name, last_name, age, gender, location, bio)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
    COALESCE((NEW.raw_user_meta_data->>'age')::INTEGER, 18),
    COALESCE(NEW.raw_user_meta_data->>'gender', 'other'),
    COALESCE(NEW.raw_user_meta_data->>'location', ''),
    COALESCE(NEW.raw_user_meta_data->>'bio', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for profiles updated_at
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE PROCEDURE public.handle_updated_at();

-- Function to create match when mutual like occurs
CREATE OR REPLACE FUNCTION public.check_mutual_like()
RETURNS TRIGGER AS $$
BEGIN
  -- Only proceed if this is a 'like' action
  IF NEW.action = 'like' THEN
    -- Check if the swiped user has also liked the swiper
    IF EXISTS (
      SELECT 1 FROM swipes 
      WHERE swiper_id = NEW.swiped_id 
      AND swiped_id = NEW.swiper_id 
      AND action = 'like'
    ) THEN
      -- Create a match (ensure consistent ordering)
      INSERT INTO matches (profile1_id, profile2_id)
      VALUES (
        LEAST(NEW.swiper_id, NEW.swiped_id),
        GREATEST(NEW.swiper_id, NEW.swiped_id)
      )
      ON CONFLICT (profile1_id, profile2_id) DO NOTHING;
      
      -- Create notifications for both users
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES 
        (NEW.swiper_id, 'match', 'New Match!', 'You have a new match!', jsonb_build_object('match_user_id', NEW.swiped_id)),
        (NEW.swiped_id, 'match', 'New Match!', 'You have a new match!', jsonb_build_object('match_user_id', NEW.swiper_id));
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to check for mutual likes
CREATE TRIGGER check_mutual_like_trigger
  AFTER INSERT ON swipes
  FOR EACH ROW EXECUTE PROCEDURE public.check_mutual_like();

-- Function to get potential matches for a user
CREATE OR REPLACE FUNCTION get_potential_matches(user_id UUID, limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  first_name TEXT,
  last_name TEXT,
  age INTEGER,
  gender TEXT,
  location TEXT,
  bio TEXT,
  avatar_url TEXT,
  distance FLOAT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.first_name,
    p.last_name,
    p.age,
    p.gender,
    p.location,
    p.bio,
    p.avatar_url,
    0.0 as distance -- Placeholder for distance calculation
  FROM profiles p
  WHERE p.id != user_id
    AND p.id NOT IN (
      SELECT swiped_id FROM swipes WHERE swiper_id = user_id
    )
    AND p.id NOT IN (
      SELECT profile1_id FROM matches WHERE profile2_id = user_id
      UNION
      SELECT profile2_id FROM matches WHERE profile1_id = user_id
    )
  ORDER BY p.last_active DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Indexes for better performance
CREATE INDEX idx_swipes_swiper_swiped ON swipes(swiper_id, swiped_id);
CREATE INDEX idx_matches_profiles ON matches(profile1_id, profile2_id);
CREATE INDEX idx_messages_match_created ON messages(match_id, created_at);
CREATE INDEX idx_profiles_location ON profiles(location);
CREATE INDEX idx_profiles_age_gender ON profiles(age, gender);
CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at);

-- Sample data (optional - for testing)
-- You can uncomment this section to add sample profiles for testing

/*
-- Insert sample profiles (make sure to create corresponding auth users first)
INSERT INTO profiles (id, first_name, last_name, age, gender, location, bio, avatar_url) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Amara', 'Okafor', 25, 'female', 'Lagos, Nigeria', 'Love dancing and exploring new places!', 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Kwame', 'Asante', 28, 'male', 'Accra, Ghana', 'Software developer who loves music and travel.', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
  ('550e8400-e29b-41d4-a716-446655440003', 'Zara', 'Mwangi', 24, 'female', 'Nairobi, Kenya', 'Artist and coffee enthusiast. Always up for an adventure!', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'),
  ('550e8400-e29b-41d4-a716-446655440004', 'Thabo', 'Molefe', 30, 'male', 'Cape Town, South Africa', 'Outdoor enthusiast and photographer.', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400');
*/