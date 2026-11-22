-- Rollback trigram indexes
DROP INDEX IF EXISTS payments_notes_trgm_idx;
DROP INDEX IF EXISTS payments_currency_trgm_idx;
DROP INDEX IF EXISTS payments_status_trgm_idx;
