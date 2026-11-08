<?php
// ============================================================
//  Every table the dashboard needs, in one place, so the first
//  run and every later upgrade build exactly the same shapes.
//  CREATE TABLE IF NOT EXISTS: running this twice is harmless.
// ============================================================
return [

'users' => "CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(120) NOT NULL,
  email         VARCHAR(190) NOT NULL,
  pass          VARCHAR(255) NOT NULL,
  role          ENUM('admin','staff') NOT NULL DEFAULT 'staff',
  status        ENUM('pending','active','disabled') NOT NULL DEFAULT 'pending',
  failed        TINYINT UNSIGNED NOT NULL DEFAULT 0,
  locked_until  DATETIME NULL,
  last_login    DATETIME NULL,
  created_at    DATETIME NOT NULL,
  UNIQUE KEY uniq_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",

'leads' => "CREATE TABLE IF NOT EXISTS leads (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  kind        ENUM('quote','order','contact') NOT NULL DEFAULT 'order',
  name        VARCHAR(120) NOT NULL,
  phone       VARCHAR(40)  NOT NULL,
  email       VARCHAR(190) NULL,
  service     VARCHAR(160) NULL,
  pool_type   VARCHAR(80)  NULL,
  pool_size   VARCHAR(80)  NULL,
  amount      DECIMAL(12,2) NULL,
  city        VARCHAR(120) NULL,
  message     TEXT NULL,
  lang        CHAR(2) NOT NULL DEFAULT 'ar',
  page        VARCHAR(190) NULL,
  ip          VARCHAR(45)  NULL,
  ua          VARCHAR(255) NULL,
  status      ENUM('new','contacted','quoted','won','lost') NOT NULL DEFAULT 'new',
  note        TEXT NULL,
  created_at  DATETIME NOT NULL,
  KEY idx_status (status),
  KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",

'projects' => "CREATE TABLE IF NOT EXISTS projects (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  slug        VARCHAR(80)  NOT NULL,
  sec         ENUM('residential','commercial','hospitality','industrial') NOT NULL DEFAULT 'residential',
  title_ar    VARCHAR(190) NOT NULL,
  title_en    VARCHAR(190) NOT NULL,
  tag         VARCHAR(40)  NULL,
  place_ar    VARCHAR(140) NULL,
  place_en    VARCHAR(140) NULL,
  client_ar   VARCHAR(140) NULL,
  client_en   VARCHAR(140) NULL,
  scope_ar    VARCHAR(190) NULL,
  scope_en    VARCHAR(190) NULL,
  year        VARCHAR(20)  NULL,
  lead_ar     TEXT NULL,
  lead_en     TEXT NULL,
  body_ar     MEDIUMTEXT NULL,
  body_en     MEDIUMTEXT NULL,
  cover       VARCHAR(190) NULL,
  featured    TINYINT(1) NOT NULL DEFAULT 0,
  sort        INT NOT NULL DEFAULT 0,
  status      ENUM('draft','live') NOT NULL DEFAULT 'live',
  created_at  DATETIME NOT NULL,
  updated_at  DATETIME NULL,
  UNIQUE KEY uniq_slug (slug),
  KEY idx_sec (sec),
  KEY idx_sort (sort)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",

'project_images' => "CREATE TABLE IF NOT EXISTS project_images (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  project_id  INT NOT NULL,
  file        VARCHAR(190) NOT NULL,
  caption_ar  VARCHAR(190) NULL,
  caption_en  VARCHAR(190) NULL,
  sort        INT NOT NULL DEFAULT 0,
  created_at  DATETIME NOT NULL,
  KEY idx_project (project_id, sort),
  CONSTRAINT fk_pimg_project FOREIGN KEY (project_id)
    REFERENCES projects (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",

];
