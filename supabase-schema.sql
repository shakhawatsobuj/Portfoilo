-- Run this SQL in your Supabase SQL Editor to set up the database schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Projects Table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title_en TEXT NOT NULL,
    title_bn TEXT,
    title_lt TEXT,
    description_en TEXT,
    description_bn TEXT,
    description_lt TEXT,
    role_en TEXT,
    role_bn TEXT,
    role_lt TEXT,
    responsibilities_en TEXT,
    responsibilities_bn TEXT,
    responsibilities_lt TEXT,
    cover_image TEXT,
    is_published BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Documents Table (For CV and other files)
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    doc_type TEXT,
    is_public BOOLEAN DEFAULT false,
    is_cv BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Enable Row Level Security (RLS)
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Public read policies (Allows anyone to read published content)
CREATE POLICY "Public can view published projects" 
ON projects FOR SELECT 
USING (is_published = true);

CREATE POLICY "Public can view public documents" 
ON documents FOR SELECT 
USING (is_public = true);

-- Admin full access policies (Allows authenticated users to do everything)
CREATE POLICY "Admin full access projects" 
ON projects FOR ALL 
USING (auth.role() = 'authenticated');

CREATE POLICY "Admin full access documents" 
ON documents FOR ALL 
USING (auth.role() = 'authenticated');

-- IMPORTANT: You must also create two Storage Buckets in your Supabase Dashboard:
-- 1. 'portfolio' (for project images) - Make it Public
-- 2. 'documents' (for CVs and certificates) - Make it Public
-- After creating them, ensure you add RLS policies to the buckets to allow authenticated users to INSERT/UPDATE/DELETE.
