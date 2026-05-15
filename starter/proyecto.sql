CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    address TEXT
);

CREATE TABLE events (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    event_type TEXT,
    event_date TEXT,
    client_id INTEGER NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT,
    quantity INTEGER,
    status TEXT CHECK(status IN ('available', 'in_use')) DEFAULT 'available'
);

CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    equipment_id INTEGER NOT NULL,
    booking_date TEXT,
    status TEXT CHECK(status IN ('pending', 'confirmed', 'completed')) DEFAULT 'pending',
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

INSERT INTO clients (name, email, phone) VALUES
('Carlos Pérez', 'carlos@email.com', '3001111111'),
('Ana Gómez', 'ana@email.com', '3002222222'),
('Luis Torres', 'luis@email.com', '3003333333'),
('María López', 'maria@email.com', '3004444444'),
('Jorge Ramírez', 'jorge@email.com', '3005555555');

INSERT INTO events (name, event_type, event_date, client_id) VALUES
('Fiesta Neon', 'Cumpleaños', '2026-06-10', 1),
('DJ Summer Fest', 'Festival', '2026-06-15', 2),
('Noche Electrónica', 'Concierto', '2026-06-20', 3),
('Boda Deluxe', 'Boda', '2026-06-25', 4),
('Pool Party', 'Fiesta', '2026-06-30', 5),
('Urban Beats', 'Festival', '2026-07-05', 1),
('Glow Party', 'Cumpleaños', '2026-07-08', 2),
('Electro Night', 'Concierto', '2026-07-12', 3),
('VIP Wedding', 'Boda', '2026-07-15', 4),
('Dance Explosion', 'Festival', '2026-07-20', 5);

INSERT INTO equipment (name, category, quantity, status) VALUES
('Parlantes JBL', 'Sonido', 10, 'available'),
('Luces LED', 'Iluminación', 20, 'in_use'),
('Consola Pioneer', 'DJ', 5, 'available'),
('Máquina de humo', 'Efectos', 3, 'available'),
('Micrófonos', 'Audio', 15, 'in_use');

INSERT INTO bookings (event_id, equipment_id, booking_date, status) VALUES
(1, 1, '2026-06-01', 'confirmed'),
(2, 2, '2026-06-02', 'pending'),
(3, 3, '2026-06-03', 'completed'),
(4, 4, '2026-06-04', 'confirmed'),
(5, 5, '2026-06-05', 'pending');

SELECT * FROM events;

SELECT events.name AS event, clients.name AS client
FROM events
JOIN clients ON events.client_id = clients.client_id;

SELECT name, event_type
FROM events
WHERE event_type = 'Festival';

SELECT * FROM equipment
WHERE status = 'available';

SELECT * FROM equipment
ORDER BY quantity DESC;

SELECT clients.name, COUNT(events.event_id) AS total_events
FROM clients
LEFT JOIN events ON clients.client_id = events.client_id
GROUP BY clients.name;

SELECT name, quantity
FROM equipment
ORDER BY quantity DESC
LIMIT 1;