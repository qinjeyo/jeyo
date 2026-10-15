-- ============================================================
-- PROJECT NOAH
-- LIBRARY AND DIGITAL ASSET MANAGEMENT SYSTEM
-- PostgreSQL / Supabase
-- FULL DATABASE SETUP
-- ============================================================
-- WARNING:
-- This is a fresh-install script. It drops existing tables.
-- Do NOT run on your current database without a backup.
-- ============================================================

BEGIN;

SET search_path TO public;

-- 1. CLEANUP
DROP VIEW IF EXISTS public.vw_download_requests CASCADE;

DROP TABLE IF EXISTS public.download_requests CASCADE;
DROP TABLE IF EXISTS public.access_logs CASCADE;
DROP TABLE IF EXISTS public.asset_categories CASCADE;
DROP TABLE IF EXISTS public.digital_assets CASCADE;
DROP TABLE IF EXISTS public.fines CASCADE;
DROP TABLE IF EXISTS public.reservations CASCADE;
DROP TABLE IF EXISTS public.borrowings CASCADE;
DROP TABLE IF EXISTS public.physical_copies CASCADE;
DROP TABLE IF EXISTS public.book_authors CASCADE;
DROP TABLE IF EXISTS public.books CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.authors CASCADE;
DROP TABLE IF EXISTS public.members CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS public.roles CASCADE;

DROP PROCEDURE IF EXISTS public.add_book(VARCHAR,VARCHAR,INTEGER,INTEGER);
DROP PROCEDURE IF EXISTS public.add_author(VARCHAR);
DROP PROCEDURE IF EXISTS public.add_digital_asset(VARCHAR,TEXT,VARCHAR,TEXT);
DROP PROCEDURE IF EXISTS public.review_download_request(INTEGER,INTEGER,VARCHAR,TEXT);

DROP FUNCTION IF EXISTS public.check_copy_available() CASCADE;
DROP FUNCTION IF EXISTS public.mark_copy_borrowed() CASCADE;
DROP FUNCTION IF EXISTS public.mark_copy_available() CASCADE;

-- 2. ROLES
CREATE TABLE public.roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO public.roles (role_name) VALUES
('Admin'),
('Librarian'),
('Staff'),
('Library Assistant'),
('Student');

-- 3. USERS
CREATE TABLE public.users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    role_id INTEGER NOT NULL REFERENCES public.roles(role_id)
);

INSERT INTO public.users (full_name, email, role_id) VALUES
('Archer', 'archer@email.com', 1),
('Cyrus', 'cyrus@email.com', 2),
('Janelle', 'janelle@email.com', 3),
('J.U Clevie Matandag', 'j.ucleviematandag@email.com', 4),
('Rob', 'rob@email.com', 5),
('Juan Dela Cruz', 'juan.delacruz@email.com', 5),
('Ana Reyes', 'ana.reyes@email.com', 5),
('Mark Lopez', 'mark.lopez@email.com', 5),
('Bea Castillo', 'bea.castillo@email.com', 5),
('Carlo Ramos', 'carlo.ramos@email.com', 5);

-- 4. MEMBERS
CREATE TABLE public.members (
    member_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE
        REFERENCES public.users(user_id) ON DELETE CASCADE,
    student_number VARCHAR(30) UNIQUE
);

-- Only Student-role users are seeded as members.
INSERT INTO public.members (user_id, student_number) VALUES
(5, '202-005'),
(6, '202-006'),
(7, '202-007'),
(8, '202-008'),
(9, '202-009'),
(10, '202-010');

-- 5. AUTHORS
CREATE TABLE public.authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(150) NOT NULL
);

INSERT INTO public.authors (author_name) VALUES
('J. L. Meriam & L. G. Kraige'),
('J. L. Meriam & L. G. Kraige'),
('Richard G. Budynas & J. Keith Nisbett'),
('Richard E. Sonntag et al.'),
('Frank M. White'),
('J. P. Holman'),
('Robert L. Norton'),
('William D. Callister Jr.'),
('Serope Kalpakjian & Steven R. Schmid'),
('Michael F. Ashby & David R. H. Jones'),
('Russell C. Hibbeler'),
('Clayton T. Crowe et al.'),
('Jack C. McCormac & Russell H. Brown'),
('S. Unnikrishna Pillai & Devdas Menon'),
('Donald P. Coduto'),
('Fred L. Mannering et al.'),
('B. C. Punmia et al.'),
('Gerard Kiely'),
('Terence J. McGhee'),
('Ram Chandra'),
('Adel S. Sedra & Kenneth C. Smith'),
('Behzad Razavi'),
('Robert L. Boylestad & Louis Nashelsky'),
('M. Morris Mano & Michael D. Ciletti'),
('Alan B. Marcovitz'),
('Ronald J. Tocci et al.'),
('Kennedy & Davis'),
('Simon Haykin'),
('Christopher Bowick'),
('Muhammad H. Rashid'),
('Stephen J. Chapman'),
('A. E. Fitzgerald et al.'),
('John J. Grainger & William D. Stevenson Jr.'),
('K. R. Padiyar'),
('Allan R. Hambley'),
('William H. Hayt Jr. et al.'),
('Alan V. Oppenheim et al.'),
('Norman S. Nise'),
('Katsuhiko Ogata'),
('Benjamin C. Kuo & Farid Golnaraghi'),
('Thomas H. Cormen et al.'),
('David A. Patterson & John L. Hennessy'),
('John L. Hennessy & David A. Patterson'),
('Albert Paul Malvino'),
('Paul Horowitz & Winfield Hill'),
('William G. Sullivan et al.'),
('Donald G. Newman et al.'),
('Garold D. Oberlender'),
('Charles B. Fleddermann'),
('Paul H. Wright');

-- 6. CATEGORIES
CREATE TABLE public.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO public.categories (category_name) VALUES
('Electrical Engineering'),
('Electromagnetic Theory'),
('Engineering Economics'),
('Computer Engineering'),
('Computer Science'),
('Mathematics'),
('Calculus'),
('Physics'),
('Digital Electronics'),
('Programming'),
('Database Management Systems'),
('Data Structures and Algorithms'),
('Artificial Intelligence'),
('Networking'),
('Software Engineering');

-- 7. BOOKS
CREATE TABLE public.books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(50) UNIQUE,
    publication_year INTEGER,
    category_id INTEGER REFERENCES public.categories(category_id)
);

INSERT INTO public.books (title, isbn, publication_year, category_id) VALUES
('Engineering Mechanics: Statics', '9780073398235', 2012, 1),
('Engineering Mechanics: Dynamics', '9780073398204', 2012, 1),
('Shigleys Mechanical Engineering Design', '9780262046305', 2014, 1),
('Fundamentals of Thermodynamics', '9781119391388', 2018, 1),
('Fluid Mechanics', '9780073398273', 2011, 1),
('Heat Transfer', '9780073529363', 2010, 1),
('Machine Design', '9780133356717', 2013, 1),
('Materials Science and Engineering', '9781119405498', 2018, 1),
('Manufacturing Engineering and Technology', '9780133128741', 2014, 1),
('Engineering Materials 1', '9780080966687', 2013, 1),
('Structural Analysis', '9780134610672', 2017, 1),
('Engineering Fluid Mechanics', '9781119723548', 2020, 1),
('Design of Reinforced Concrete', '9781119320792', 2015, 1),
('Foundation Design', '9780132132914', 2008, 1),
('Principles of Highway Engineering and Traffic Analysis', '9781119493961', 2020, 1),
('Surveying', '9780134604657', 2016, 1),
('Environmental Engineering', '9780073401180', 2009, 1),
('Water Supply and Sewerage', '9780070609388', 1991, 1),
('Steel Structures', '9780074516454', 2014, 1),
('Microelectronic Circuits', '9780190853464', 2019, 9),
('Fundamentals of Microelectronics', '9781118156322', 2013, 9),
('Electronic Devices and Circuit Theory', '9780132622264', 2013, 9),
('Digital Design', '9780132774208', 2012, 9),
('Digital Logic Design', '9780471364912', 2005, 9),
('Digital Systems: Principles and Applications', '9780134529657', 2017, 9),
('Electronic Communication Systems', '9780070667504', 2001, 9),
('Communication Systems', '9780471697909', 2008, 14),
('RF Circuit Design', '9780750675188', 2003, 9),
('Power Electronics', '9780133125900', 2014, 9),
('Electrical Machinery Fundamentals', '9780073529547', 2011, 1),
('Electric Machinery', '9780073380469', 2009, 1),
('Power System Analysis', '9780070612938', 1994, 1),
('Power System Engineering', '9788120335618', 2006, 1),
('Electrical Engineering: Principles and Applications', '9780133116649', 2014, 1),
('Engineering Circuit Analysis', '9780073380575', 2011, 1),
('Signals and Systems', '9780138147570', 1996, 4),
('Control Systems Engineering', '9781118170519', 2014, 4),
('Modern Control Engineering', '9780136156734', 2010, 4),
('Automatic Control Systems', '9780470048962', 2009, 4),
('Introduction to Algorithms', '12345', 2022, 12),
('Computer Organization and Design', '678', 2020, 4),
('Computer Architecture', '91011', 2019, 4),
('Digital Computer Electronics', '9780071005965', 1992, 9),
('The Art of Electronics', '9780521809269', 2015, 9),
('Engineering Economy', '9780073376301', 2014, 3),
('Engineering Economic Analysis', '9780199339274', 2016, 3),
('Project Management for Engineering and Construction', '9780071822314', 2014, 4),
('Engineering Ethics', '9781107182000', 2017, 4),
('Introduction to Engineering', '9780073397948', 2013, 4);

-- 8. BOOK AUTHORS
CREATE TABLE public.book_authors (
    book_id INTEGER NOT NULL REFERENCES public.books(book_id) ON DELETE CASCADE,
    author_id INTEGER NOT NULL REFERENCES public.authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- These are the book-author links explicitly included in the supplied source.
INSERT INTO public.book_authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- 9. PHYSICAL COPIES
CREATE TABLE public.physical_copies (
    copy_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES public.books(book_id),
    status VARCHAR(30) NOT NULL DEFAULT 'Available'
        CHECK (status IN ('Available', 'Borrowed', 'Lost', 'Damaged'))
);

INSERT INTO public.physical_copies (book_id, status) VALUES
(1, 'Available'),
(1, 'Available'),
(2, 'Available'),
(3, 'Available');

-- 10. BORROWINGS
CREATE TABLE public.borrowings (
    borrowing_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES public.members(member_id),
    copy_id INTEGER NOT NULL REFERENCES public.physical_copies(copy_id),
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    CHECK (due_date >= borrow_date),
    CHECK (return_date IS NULL OR return_date >= borrow_date)
);

-- 11. RESERVATIONS
CREATE TABLE public.reservations (
    reservation_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES public.members(member_id),
    book_id INTEGER NOT NULL REFERENCES public.books(book_id),
    reservation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'Fulfilled', 'Cancelled'))
);

-- 12. FINES
CREATE TABLE public.fines (
    fine_id SERIAL PRIMARY KEY,
    borrowing_id INTEGER NOT NULL REFERENCES public.borrowings(borrowing_id),
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    status VARCHAR(30) NOT NULL DEFAULT 'Unpaid'
        CHECK (status IN ('Unpaid', 'Paid', 'Waived'))
);

-- 13. DIGITAL ASSETS
CREATE TABLE public.digital_assets (
    asset_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    file_type VARCHAR(50),
    file_url TEXT
);

INSERT INTO public.digital_assets (title, description, file_type, file_url) VALUES
('Computer Engineering Reviewer',
 'COMPUTER ELECTRONIC FOR ENINEERING',
 'PDF', 'computer-engineering-reviewer.pdf'),
('Library Rules and Regulations',
 'Rules and guidelines for library users',
 'PDF', 'library-rules.pdf'),
('Programming Basics',
 'Introduction to basic programming concepts',
 'PDF', 'programming-basics.pdf');

-- 14. ASSET CATEGORIES
CREATE TABLE public.asset_categories (
    asset_id INTEGER NOT NULL REFERENCES public.digital_assets(asset_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES public.categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (asset_id, category_id)
);

INSERT INTO public.asset_categories (asset_id, category_id) VALUES
(1, 3),
(2, 2),
(3, 1);

-- 15. ACCESS LOGS
CREATE TABLE public.access_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES public.users(user_id),
    asset_id INTEGER NOT NULL REFERENCES public.digital_assets(asset_id),
    access_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 16. DOWNLOAD REQUESTS
-- ============================================================

CREATE TABLE public.download_requests (
    request_id BIGSERIAL PRIMARY KEY,

    member_id INTEGER NOT NULL
        REFERENCES public.members(member_id) ON DELETE CASCADE,

    asset_id INTEGER NOT NULL
        REFERENCES public.digital_assets(asset_id) ON DELETE CASCADE,

    request_reason TEXT,

    status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'Approved', 'Rejected')),

    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    reviewed_by INTEGER
        REFERENCES public.users(user_id) ON DELETE SET NULL,

    reviewed_at TIMESTAMPTZ,

    review_note TEXT,

    CHECK (
        (status = 'Pending' AND reviewed_at IS NULL)
        OR
        (status IN ('Approved', 'Rejected') AND reviewed_at IS NOT NULL)
    )
);

-- Prevent duplicate pending requests for the same asset.
CREATE UNIQUE INDEX uq_pending_download_request
ON public.download_requests(member_id, asset_id)
WHERE status = 'Pending';

-- ============================================================
-- 17. BORROWING TRIGGERS
-- ============================================================

CREATE OR REPLACE FUNCTION public.check_copy_available()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(30);
BEGIN
    SELECT status
    INTO v_status
    FROM public.physical_copies
    WHERE copy_id = NEW.copy_id
    FOR UPDATE;

    IF v_status IS DISTINCT FROM 'Available' THEN
        RAISE EXCEPTION
            'Copy % is not available. Current status: %',
            NEW.copy_id,
            COALESCE(v_status, 'Not found');
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_copy_available
BEFORE INSERT ON public.borrowings
FOR EACH ROW
EXECUTE FUNCTION public.check_copy_available();


CREATE OR REPLACE FUNCTION public.mark_copy_borrowed()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.physical_copies
    SET status = 'Borrowed'
    WHERE copy_id = NEW.copy_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_mark_copy_borrowed
AFTER INSERT ON public.borrowings
FOR EACH ROW
EXECUTE FUNCTION public.mark_copy_borrowed();


CREATE OR REPLACE FUNCTION public.mark_copy_available()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        UPDATE public.physical_copies
        SET status = 'Available'
        WHERE copy_id = NEW.copy_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_mark_copy_available
AFTER UPDATE OF return_date ON public.borrowings
FOR EACH ROW
EXECUTE FUNCTION public.mark_copy_available();

-- ============================================================
-- 18. ADMIN / LIBRARIAN REVIEW PROCEDURE
-- ============================================================

CREATE OR REPLACE PROCEDURE public.review_download_request(
    p_request_id BIGINT,
    p_reviewer_user_id INTEGER,
    p_decision VARCHAR,
    p_review_note TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_role_name VARCHAR(50);
    v_status VARCHAR(20);
BEGIN
    IF p_decision NOT IN ('Approved', 'Rejected') THEN
        RAISE EXCEPTION 'Decision must be Approved or Rejected.';
    END IF;

    SELECT r.role_name
    INTO v_role_name
    FROM public.users u
    JOIN public.roles r ON r.role_id = u.role_id
    WHERE u.user_id = p_reviewer_user_id;

    IF v_role_name IS NULL
       OR v_role_name NOT IN ('Admin', 'Librarian') THEN
        RAISE EXCEPTION
            'Only an Admin or Librarian may review download requests.';
    END IF;

    SELECT status
    INTO v_status
    FROM public.download_requests
    WHERE request_id = p_request_id
    FOR UPDATE;

    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Download request % not found.', p_request_id;
    END IF;

    IF v_status <> 'Pending' THEN
        RAISE EXCEPTION 'Only Pending requests can be reviewed.';
    END IF;

    UPDATE public.download_requests
    SET status = p_decision,
        reviewed_by = p_reviewer_user_id,
        reviewed_at = NOW(),
        review_note = p_review_note
    WHERE request_id = p_request_id;
END;
$$;

-- ============================================================
-- 19. DOWNLOAD REQUEST REVIEW VIEW
-- ============================================================

CREATE OR REPLACE VIEW public.vw_download_requests AS
SELECT
    dr.request_id,
    dr.member_id,
    student.full_name AS student_name,
    student.email AS student_email,
    m.student_number,
    dr.asset_id,
    da.title AS asset_title,
    da.file_type,
    dr.request_reason,
    dr.status,
    dr.requested_at,
    dr.reviewed_by,
    reviewer.full_name AS reviewer_name,
    dr.reviewed_at,
    dr.review_note
FROM public.download_requests dr
JOIN public.members m
    ON m.member_id = dr.member_id
JOIN public.users student
    ON student.user_id = m.user_id
JOIN public.digital_assets da
    ON da.asset_id = dr.asset_id
LEFT JOIN public.users reviewer
    ON reviewer.user_id = dr.reviewed_by;

-- ============================================================
-- 20. OTHER STORED PROCEDURES
-- ============================================================

CREATE OR REPLACE PROCEDURE public.add_book(
    p_title VARCHAR,
    p_isbn VARCHAR,
    p_publication_year INTEGER,
    p_category_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.books
        (title, isbn, publication_year, category_id)
    VALUES
        (p_title, p_isbn, p_publication_year, p_category_id);
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_author(
    p_author_name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.authors (author_name)
    VALUES (p_author_name);
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_digital_asset(
    p_title VARCHAR,
    p_description TEXT,
    p_file_type VARCHAR,
    p_file_url TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.digital_assets
        (title, description, file_type, file_url)
    VALUES
        (p_title, p_description, p_file_type, p_file_url);
END;
$$;

-- ============================================================
-- 21. INDEXES
-- ============================================================

CREATE INDEX idx_users_role
    ON public.users(role_id);

CREATE INDEX idx_books_category
    ON public.books(category_id);

CREATE INDEX idx_book_authors_book
    ON public.book_authors(book_id);

CREATE INDEX idx_book_authors_author
    ON public.book_authors(author_id);

CREATE INDEX idx_physical_copies_book
    ON public.physical_copies(book_id);

CREATE INDEX idx_borrowings_member
    ON public.borrowings(member_id);

CREATE INDEX idx_borrowings_copy
    ON public.borrowings(copy_id);

CREATE INDEX idx_fines_borrowing
    ON public.fines(borrowing_id);

CREATE INDEX idx_reservations_member
    ON public.reservations(member_id);

CREATE INDEX idx_reservations_book
    ON public.reservations(book_id);

CREATE INDEX idx_asset_categories_category
    ON public.asset_categories(category_id);

CREATE INDEX idx_access_logs_user
    ON public.access_logs(user_id);

CREATE INDEX idx_access_logs_asset
    ON public.access_logs(asset_id);

CREATE INDEX idx_download_requests_member
    ON public.download_requests(member_id);

CREATE INDEX idx_download_requests_asset
    ON public.download_requests(asset_id);

CREATE INDEX idx_download_requests_status
    ON public.download_requests(status);

CREATE INDEX idx_download_requests_reviewer
    ON public.download_requests(reviewed_by);


-- ============================================================
-- 22. SAMPLE BORROWING AND FINE
-- ============================================================

-- Sample borrowing: member 1 borrows physical copy 2.
-- The trigger automatically changes the copy status to Borrowed.
INSERT INTO public.borrowings
    (member_id, copy_id, borrow_date, due_date, return_date)
VALUES
    (1, 2, DATE '2026-10-01', DATE '2026-10-08', NULL);

INSERT INTO public.fines
    (borrowing_id, amount, status)
VALUES
    (1, 100.00, 'Unpaid');

-- ============================================================
-- 23. SAMPLE RESERVATION
-- ============================================================

INSERT INTO public.reservations
    (member_id, book_id, reservation_date, status)
VALUES
    (1, 2, DATE '2026-10-02', 'Pending');

-- ============================================================
-- 24. SAMPLE ACCESS LOG
-- ============================================================

INSERT INTO public.access_logs (user_id, asset_id)
VALUES (5, 1);

-- ============================================================
-- 25. SAMPLE DOWNLOAD REQUEST
-- ============================================================

-- Student/member 1 requests digital asset 1.
-- It starts as Pending and is NOT yet downloadable.
INSERT INTO public.download_requests
    (member_id, asset_id, request_reason)
VALUES
    (1, 1, 'Requesting access for academic study.');

-- ============================================================
-- 26. COMMIT THE DATABASE SETUP
-- ============================================================

COMMIT;

-- ============================================================
-- 27. VERIFICATION QUERIES
-- Run these separately after the setup succeeds.
-- ============================================================

-- List all roles
SELECT * FROM public.roles ORDER BY role_id;

-- List users and roles
SELECT
    u.user_id,
    u.full_name,
    u.email,
    r.role_name
FROM public.users u
JOIN public.roles r ON r.role_id = u.role_id
ORDER BY u.user_id;

-- List student/member records
SELECT
    m.member_id,
    u.full_name,
    u.email,
    m.student_number
FROM public.members m
JOIN public.users u ON u.user_id = m.user_id
ORDER BY m.member_id;

-- List books, categories, and authors where a link exists
SELECT
    b.book_id,
    b.title,
    b.isbn,
    b.publication_year,
    c.category_name,
    a.author_name
FROM public.books b
LEFT JOIN public.categories c
    ON c.category_id = b.category_id
LEFT JOIN public.book_authors ba
    ON ba.book_id = b.book_id
LEFT JOIN public.authors a
    ON a.author_id = ba.author_id
ORDER BY b.book_id;

-- Count books by category
SELECT
    c.category_name,
    COUNT(b.book_id) AS total_books
FROM public.categories c
LEFT JOIN public.books b
    ON b.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_name;

-- List physical copies and current status
SELECT
    pc.copy_id,
    b.title,
    pc.status
FROM public.physical_copies pc
JOIN public.books b ON b.book_id = pc.book_id
ORDER BY pc.copy_id;

-- List borrowings
SELECT
    br.borrowing_id,
    u.full_name AS member_name,
    b.title,
    pc.status AS copy_status,
    br.borrow_date,
    br.due_date,
    br.return_date
FROM public.borrowings br
JOIN public.members m ON m.member_id = br.member_id
JOIN public.users u ON u.user_id = m.user_id
JOIN public.physical_copies pc ON pc.copy_id = br.copy_id
JOIN public.books b ON b.book_id = pc.book_id
ORDER BY br.borrowing_id;

-- List digital assets
SELECT * FROM public.digital_assets ORDER BY asset_id;

-- Librarian/Admin review queue
SELECT *
FROM public.vw_download_requests
ORDER BY requested_at DESC;

-- Count all main records
SELECT 'Roles' AS table_name, COUNT(*) AS total FROM public.roles
UNION ALL
SELECT 'Users', COUNT(*) FROM public.users
UNION ALL
SELECT 'Members', COUNT(*) FROM public.members
UNION ALL
SELECT 'Authors', COUNT(*) FROM public.authors
UNION ALL
SELECT 'Categories', COUNT(*) FROM public.categories
UNION ALL
SELECT 'Books', COUNT(*) FROM public.books
UNION ALL
SELECT 'Book_Authors', COUNT(*) FROM public.book_authors
UNION ALL
SELECT 'Physical_Copies', COUNT(*) FROM public.physical_copies
UNION ALL
SELECT 'Borrowings', COUNT(*) FROM public.borrowings
UNION ALL
SELECT 'Reservations', COUNT(*) FROM public.reservations
UNION ALL
SELECT 'Fines', COUNT(*) FROM public.fines
UNION ALL
SELECT 'Digital_Assets', COUNT(*) FROM public.digital_assets
UNION ALL
SELECT 'Asset_Categories', COUNT(*) FROM public.asset_categories
UNION ALL
SELECT 'Access_Logs', COUNT(*) FROM public.access_logs
UNION ALL
SELECT 'Download_Requests', COUNT(*) FROM public.download_requests
ORDER BY table_name;
