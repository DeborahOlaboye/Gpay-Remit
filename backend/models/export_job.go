package models

import (
	"database/sql/driver"
	"encoding/json"
	"time"

	"gorm.io/datatypes"
	"gorm.io/gorm"
)

type ExportJob struct {
	ID           int64              `gorm:"primaryKey" json:"id"`
	CreatedAt    time.Time          `json:"created_at"`
	UpdatedAt    time.Time          `json:"updated_at"`
	DeletedAt    gorm.DeletedAt     `gorm:"index" json:"-"`
	UserID       uint               `gorm:"index;not null" json:"user_id"`
	Format       string             `gorm:"size:10;not null" json:"format"`
	Status       string             `gorm:"index;size:20;default:'pending'" json:"status"`
	FilePath     string             `json:"file_path,omitempty"`
	ErrorMessage string             `json:"error_message,omitempty"`
	RowCount     int32              `json:"row_count"`
	Filters      datatypes.JSONType `gorm:"type:jsonb" json:"filters,omitempty"`
}

func (ExportJob) TableName() string {
	return "export_jobs"
}
