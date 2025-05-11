CREATE TABLE `carStock` (
  `model` varchar(65) NOT NULL DEFAULT 'none',
  `stock` int(3) NOT NULL DEFAULT 9
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `carStock`
  ADD PRIMARY KEY (`model`);
COMMIT;

CREATE TABLE `owned_vehicles` (
  `owner` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `plate` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehicle` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'car',
  `job` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stored` tinyint(1) NOT NULL DEFAULT 0,
  `health` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `garage` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ime` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slika` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trunk` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `glovebox` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `owned_vehicles`
  ADD PRIMARY KEY (`plate`);
COMMIT;
