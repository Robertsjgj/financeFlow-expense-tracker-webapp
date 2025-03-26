/*
  # Initial Schema for FinanceFlow

  1. New Tables
    - users (managed by Supabase Auth)
    - transactions
      - id (uuid, primary key)
      - user_id (references auth.users)
      - amount (decimal)
      - category (text)
      - description (text)
      - date (timestamp)
      - type (text) - 'income' or 'expense'
    - budgets
      - id (uuid, primary key)
      - user_id (references auth.users)
      - category (text)
      - amount (decimal)
      - period (text) - 'weekly' or 'monthly'
    - savings_goals
      - id (uuid, primary key)
      - user_id (references auth.users)
      - name (text)
      - target_amount (decimal)
      - current_amount (decimal)
      - target_date (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for user data access
*/

-- Transactions table
CREATE TABLE transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  amount decimal NOT NULL,
  category text NOT NULL,
  description text,
  date timestamptz DEFAULT now(),
  type text NOT NULL CHECK (type IN ('income', 'expense')),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD their own transactions"
  ON transactions
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Budgets table
CREATE TABLE budgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  category text NOT NULL,
  amount decimal NOT NULL,
  period text NOT NULL CHECK (period IN ('weekly', 'monthly')),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD their own budgets"
  ON budgets
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Savings goals table
CREATE TABLE savings_goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  name text NOT NULL,
  target_amount decimal NOT NULL,
  current_amount decimal DEFAULT 0,
  target_date timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE savings_goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD their own savings goals"
  ON savings_goals
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);