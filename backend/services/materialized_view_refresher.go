package services

import (
	"fmt"
	"time"

	"github.com/Gpay-Remit/gpay-remit/logger"
	"gorm.io/gorm"
)

type MaterializedViewRefresher struct {
	db *gorm.DB
}

func NewMaterializedViewRefresher(db *gorm.DB) *MaterializedViewRefresher {
	return &MaterializedViewRefresher{db: db}
}

// StartPeriodicRefresh starts a background worker that refreshes materialized views hourly
func (r *MaterializedViewRefresher) StartPeriodicRefresh() {
	ticker := time.NewTicker(1 * time.Hour)
	go func() {
		for range ticker.C {
			if err := r.RefreshAnalyticsView(); err != nil {
				logger.Log.Errorf("Failed to refresh analytics materialized view: %v", err)
			}
		}
	}()
}

// RefreshAnalyticsView refreshes the daily_analytics_metrics materialized view
func (r *MaterializedViewRefresher) RefreshAnalyticsView() error {
	startTime := time.Now()
	err := r.db.Exec("REFRESH MATERIALIZED VIEW CONCURRENTLY daily_analytics_metrics").Error
	if err != nil {
		return fmt.Errorf("failed to refresh daily_analytics_metrics: %w", err)
	}

	duration := time.Since(startTime)
	logger.Log.Infof("Successfully refreshed daily_analytics_metrics in %v", duration)
	return nil
}
