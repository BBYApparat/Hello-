-- Fix MDT Database Collation Issues
-- This script aligns all MDT tables to use the same collation as the main users table

-- First, check current collations
SELECT 
    TABLE_NAME,
    TABLE_COLLATION
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME IN ('users', 'mdt_people', 'mdt_vehicles', 'mdt_reports', 'mdt_warrants', 'mdt_callsigns', 'mdt_evidence', 'owned_vehicles', 'properties');

-- Convert MDT tables to match the users table collation (utf8mb4_general_ci)
ALTER TABLE mdt_people CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE mdt_vehicles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE mdt_reports CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE mdt_warrants CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE mdt_callsigns CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE mdt_evidence CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- If owned_vehicles uses different collation, fix it too
-- ALTER TABLE owned_vehicles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Verify the changes
SELECT 
    TABLE_NAME,
    TABLE_COLLATION
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME LIKE 'mdt_%';