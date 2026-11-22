-- Create materialized view for daily aggregated metrics
CREATE MATERIALIZED VIEW IF NOT EXISTS daily_analytics_metrics AS
SELECT
  DATE(created_at) as date,
  COUNT(*) as transaction_count,
  COUNT(CASE WHEN status = 'completed' THEN 1 END) as successful_count,
  COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_count,
  COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_count,
  SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as total_volume,
  SUM(CASE WHEN status = 'completed' THEN fee ELSE 0 END) as total_fees,
  SUM(CASE WHEN status = 'completed' THEN platform_fee ELSE 0 END) as platform_fees,
  SUM(CASE WHEN status = 'completed' THEN forex_fee ELSE 0 END) as forex_fees,
  SUM(CASE WHEN status = 'completed' THEN compliance_fee ELSE 0 END) as compliance_fees,
  SUM(CASE WHEN status = 'completed' THEN network_fee ELSE 0 END) as network_fees,
  COUNT(DISTINCT currency) as currency_count,
  COUNT(DISTINCT sender_id) as unique_senders,
  COUNT(DISTINCT recipient_id) as unique_recipients
FROM payments
WHERE deleted_at IS NULL
GROUP BY DATE(created_at);

-- Create unique index on the materialized view for REFRESH MATERIALIZED VIEW CONCURRENTLY
CREATE UNIQUE INDEX idx_daily_analytics_date ON daily_analytics_metrics(date);
