-- Add pg_trgm extension for trigram-based fuzzy matching on payment notes
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Add trigram index for similarity searches on notes
CREATE INDEX IF NOT EXISTS payments_notes_trgm_idx ON payments USING GIN (notes gin_trgm_ops);

-- Add trigram index for similarity searches on currency
CREATE INDEX IF NOT EXISTS payments_currency_trgm_idx ON payments USING GIN (currency gin_trgm_ops);

-- Add trigram index for similarity searches on status
CREATE INDEX IF NOT EXISTS payments_status_trgm_idx ON payments USING GIN (status gin_trgm_ops);
