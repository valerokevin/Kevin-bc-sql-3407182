PRAGMA foreign_keys = ON;

-- =====================================================
-- TABLA DE CLIENTES
-- =====================================================

CREATE TABLE IF NOT EXISTS clients (
    client_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    created_at DATE DEFAULT CURRENT_DATE
);

-- =====================================================
-- TABLA DE EVENTOS
-- =====================================================

CREATE TABLE IF NOT EXISTS events (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    event_type TEXT NOT NULL,
    event_date DATE NOT NULL,
    client_id INTEGER NOT NULL,
    status TEXT DEFAULT 'scheduled'
    CHECK(status IN ('scheduled', 'completed', 'cancelled')),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- =====================================================
-- TABLA DE EQUIPOS
-- =====================================================

CREATE TABLE IF NOT EXISTS equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    status TEXT DEFAULT 'available'
    CHECK(status IN ('available', 'in_use', 'maintenance'))
);

-- =====================================================
-- TABLA DE RESERVAS
-- =====================================================

CREATE TABLE IF NOT EXISTS bookings (
    booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    equipment_id INTEGER NOT NULL,
    booking_date DATE DEFAULT CURRENT_DATE,
    status TEXT DEFAULT 'confirmed'
    CHECK(status IN ('confirmed', 'pending', 'cancelled')),
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

-- =====================================================
-- INSERTAR CLIENTES
-- =====================================================

INSERT INTO clients (name, email, phone) VALUES
('Carlos Pérez', 'carlos@email.com', '3001111111'),
('Ana Gómez', 'ana@email.com', '3002222222'),
('Luis Torres', 'luis@email.com', '3003333333'),
('María López', 'maria@email.com', '3004444444'),
('Jorge Ramírez', 'jorge@email.com', '3005555555');

-- =====================================================
-- INSERTAR EVENTOS
-- =====================================================

INSERT INTO events (name, event_type, event_date, client_id) VALUES
('Fiesta Neon', 'Festival', '2026-06-10', 1),
('DJ Summer Fest', 'Concierto', '2026-06-15', 2),
('Glow Party', 'Cumpleaños', '2026-06-20', 3),
('VIP Wedding', 'Boda', '2026-06-25', 4),
('Dance Explosion', 'Festival', '2026-06-30', 5);

-- =====================================================
-- INSERTAR EQUIPOS
-- =====================================================

INSERT INTO equipment (name, category, quantity, status) VALUES
('Parlantes JBL', 'Sonido', 10, 'available'),
('Luces LED', 'Iluminación', 20, 'in_use'),
('Consola Pioneer', 'DJ', 5, 'available'),
('Máquina de humo', 'Efectos', 3, 'maintenance'),
('Micrófonos', 'Audio', 15, 'available');

-- =====================================================
-- INSERTAR RESERVAS
-- =====================================================

INSERT INTO bookings (event_id, equipment_id, status) VALUES
(1, 1, 'confirmed'),
(2, 2, 'pending'),
(3, 3, 'confirmed'),
(4, 4, 'confirmed'),
(5, 5, 'pending');

-- =====================================================
-- ACTUALIZAR TELÉFONO DE CLIENTE
-- =====================================================

UPDATE clients
SET phone = '3119999999'
WHERE client_id = 3;

-- =====================================================
-- ACTUALIZAR ESTADO DE EQUIPO
-- =====================================================

UPDATE equipment
SET status = 'maintenance'
WHERE equipment_id = 2;

-- =====================================================
-- CONSULTAR CLIENTES
-- =====================================================

SELECT
    client_id AS id_cliente,
    name AS nombre_cliente,
    email AS correo
FROM clients;

-- =====================================================
-- CONSULTAR EVENTOS
-- =====================================================

SELECT
    event_id AS id_evento,
    name AS nombre_evento,
    event_type AS tipo_evento,
    status AS estado
FROM events;

-- =====================================================
-- CONSULTAR EQUIPOS
-- =====================================================

SELECT
    equipment_id AS id_equipo,
    name AS nombre_equipo,
    category AS categoria,
    quantity AS cantidad,
    status AS estado
FROM equipment;

-- =====================================================
-- CONSULTAR EVENTOS Y CLIENTES
-- =====================================================

SELECT
    events.name AS evento,
    clients.name AS cliente
FROM events
JOIN clients
ON events.client_id = clients.client_id;

-- =====================================================
-- CONSULTAR EQUIPOS DISPONIBLES
-- =====================================================

SELECT
    equipment_id,
    name,
    status
FROM equipment
WHERE status = 'available';

-- =====================================================
-- CONSULTAR EQUIPOS EN MANTENIMIENTO
-- =====================================================

SELECT
    equipment_id,
    name,
    status
FROM equipment
WHERE status = 'maintenance';

-- =====================================================
-- CONSULTAR EVENTOS ORDENADOS
-- =====================================================

SELECT
    event_id,
    name,
    event_date
FROM events
ORDER BY event_date ASC;

-- =====================================================
-- CONTAR EVENTOS POR CLIENTE
-- =====================================================

SELECT
    clients.name AS cliente,
    COUNT(events.event_id) AS total_eventos
FROM clients
LEFT JOIN events
ON clients.client_id = events.client_id
GROUP BY clients.name;

-- =====================================================
-- PAGINACIÓN PRIMERA PÁGINA
-- =====================================================

SELECT
    equipment_id,
    name,
    category
FROM equipment
LIMIT 5 OFFSET 0;

-- =====================================================
-- PAGINACIÓN SEGUNDA PÁGINA
-- =====================================================

SELECT
    equipment_id,
    name,
    category
FROM equipment
LIMIT 5 OFFSET 5;

-- =====================================================
-- SEMANA 5
-- BETWEEN - IN - LIKE
-- =====================================================

-- BETWEEN

SELECT
    equipment_id,
    name,
    quantity
FROM equipment
WHERE quantity BETWEEN 5 AND 20;

-- BETWEEN FECHAS

SELECT
    event_id,
    name,
    event_date
FROM events
WHERE event_date BETWEEN '2026-06-10' AND '2026-06-30';

-- IN

SELECT
    event_id,
    name,
    event_type
FROM events
WHERE event_type IN ('Festival', 'Boda');

-- IN EQUIPOS

SELECT
    equipment_id,
    name,
    status
FROM equipment
WHERE status IN ('available', 'in_use');

-- LIKE EVENTOS

SELECT
    event_id,
    name
FROM events
WHERE name LIKE 'DJ%';

-- LIKE CLIENTES

SELECT
    client_id,
    name,
    email
FROM clients
WHERE name LIKE '%Torres%';

-- CONSULTA COMBINADA

SELECT
    equipment_id,
    name,
    category,
    quantity,
    status
FROM equipment
WHERE quantity BETWEEN 5 AND 20
AND category IN ('Sonido', 'DJ')
AND name LIKE '%JBL%'
ORDER BY quantity DESC;

-- =====================================================
-- SEMANA 6
-- FUNCIONES DE AGREGACIÓN
-- =====================================================

-- =========================================
-- COUNT
-- TOTAL DE EVENTOS REGISTRADOS
-- =========================================

SELECT
    COUNT(*) AS total_eventos
FROM events;

-- =========================================
-- SUM Y AVG
-- SUMA Y PROMEDIO DE EQUIPOS
-- =========================================

SELECT
    SUM(quantity) AS suma_equipos,
    AVG(quantity) AS promedio_equipos
FROM equipment;

-- =========================================
-- GROUP BY
-- CANTIDAD DE EVENTOS POR TIPO
-- =========================================

SELECT
    event_type AS tipo_evento,
    COUNT(event_id) AS cantidad_eventos
FROM events
GROUP BY event_type;

-- =========================================
-- GROUP BY
-- CANTIDAD DE EQUIPOS POR ESTADO
-- =========================================

SELECT
    status AS estado_equipo,
    COUNT(equipment_id) AS cantidad
FROM equipment
GROUP BY status;

-- =========================================
-- HAVING
-- TIPOS DE EVENTOS CON MÁS DE 1 REGISTRO
-- =========================================

SELECT
    event_type AS tipo_evento,
    COUNT(event_id) AS cantidad
FROM events
GROUP BY event_type
HAVING COUNT(event_id) > 1;

-- =========================================
-- HAVING
-- CATEGORÍAS CON PROMEDIO MAYOR A 5
-- =========================================

SELECT
    category AS categoria,
    AVG(quantity) AS promedio
FROM equipment
GROUP BY category
HAVING AVG(quantity) > 5;

-- =========================================
-- REPORTE COMPLETO
-- EVENTOS POR CLIENTE
-- =========================================

SELECT
    clients.name AS cliente,
    COUNT(events.event_id) AS total_eventos
FROM clients
LEFT JOIN events
ON clients.client_id = events.client_id
GROUP BY clients.name
HAVING COUNT(events.event_id) >= 1
ORDER BY total_eventos DESC;