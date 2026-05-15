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
    quantity AS cantidad
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

-- =========================================
-- BETWEEN
-- CONSULTAR EQUIPOS CON CANTIDAD
-- ENTRE 5 Y 20
-- =========================================

SELECT
    equipment_id,
    name,
    quantity
FROM equipment
WHERE quantity BETWEEN 5 AND 20;

-- =========================================
-- BETWEEN
-- CONSULTAR EVENTOS ENTRE FECHAS
-- =========================================

SELECT
    event_id,
    name,
    event_date
FROM events
WHERE event_date BETWEEN '2026-06-10' AND '2026-06-30';

-- =========================================
-- IN
-- CONSULTAR EVENTOS TIPO FESTIVAL Y BODA
-- =========================================

SELECT
    event_id,
    name,
    event_type
FROM events
WHERE event_type IN ('Festival', 'Boda');

-- =========================================
-- IN
-- CONSULTAR EQUIPOS DISPONIBLES Y EN USO
-- =========================================

SELECT
    equipment_id,
    name,
    status
FROM equipment
WHERE status IN ('available', 'in_use');

-- =========================================
-- LIKE
-- BUSCAR EVENTOS QUE EMPIECEN POR DJ
-- =========================================

SELECT
    event_id,
    name
FROM events
WHERE name LIKE 'DJ%';

-- =========================================
-- LIKE
-- BUSCAR CLIENTES CON EL APELLIDO TORRES
-- =========================================

SELECT
    client_id,
    name,
    email
FROM clients
WHERE name LIKE '%Torres%';

-- =========================================
-- CONSULTA COMBINADA
-- BETWEEN + IN + LIKE
-- =========================================

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