-- generic user input for the user role (table generated in the migration)
-- generates a user using current timestamp and sets email with encrypted password
INSERT INTO
    auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) (
        select
            '00000000-0000-0000-0000-000000000000',
            'c9013501-e1db-4bf8-aca2-572ffc0b4e19',
            'authenticated',
            'authenticated',
            'pleasework@fortheloveofgod.ca',
            '$2a$10$fb5bC6D/HBGe4D8BYzG4zuTsSTzJeXjrXGS6XTufRH0BsXbhiRnQO',
            current_timestamp,
            current_timestamp,
            current_timestamp,
            '{"provider":"email","providers":["email"]}',
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
    );

INSERT INTO
    "public"."role" ("id", "created_at", "role")
VALUES
    (
        'c9013501-e1db-4bf8-aca2-572ffc0b4e19',
        '2026-02-21 00:34:59+00',
        'viewer'
    );

INSERT INTO site (id, name, borden, created_at, updated_at) VALUES 
('11111111-1111-1111-1111-111111111111', '', 'DiRx-28', now(), now()),
('22222222-2222-2222-2222-222222222222', '', 'DiRx-7', now(), now());

INSERT INTO area (id, name, created_at, updated_at) VALUES
('33333333-3333-3333-3333-333333333333', 'Western End of Slope', now(), now()),
('44444444-4444-4444-4444-444444444444', 'Eastern End of Slope', now(), now());

INSERT INTO site_area (site_id, area_id) VALUES
('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333'),
('22222222-2222-2222-2222-222222222222', '44444444-4444-4444-4444-444444444444');

INSERT INTO unit (id, site_id, name, created_at, updated_at) VALUES
('55555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111', 'N84SW1', now(), now()),
('66666666-6666-6666-6666-666666666666', '22222222-2222-2222-2222-222222222222', 'N100SW2', now(), now());

INSERT INTO level 
(id, unit_id, parent_id, name, up_limit, low_limit, created_at, updated_at, level_char, level_int) 
VALUES
('77777777-7777-7777-7777-777777777777', '55555555-5555-5555-5555-555555555555', NULL, 'Level 1', 0, 0, now(), now(), NULL, 0);

INSERT INTO assemblage(id, level_id, name, created_at, updated_at) VALUES
('88888888-8888-8888-8888-888888888888', '77777777-7777-7777-7777-777777777777', 'Level 1 Faunal Assemblage', now(), now());

INSERT INTO artifact_faunal
(id, assemblage_id, porosity, size_upper, size_lower, comment, pre_excav_frags, post_excav_frags, elements, created_at, updated_at)
VALUES
('99999999-9999-9999-9999-999999999999', '88888888-8888-8888-8888-888888888888', 4, 3, 2, '', 1, 1, 1, now(), now());

-- Test credentials for login_sys_test
INSERT INTO
    auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) (
        select
            '00000000-0000-0000-0000-000000000000',
            'c9013501-e1db-4bf8-aca2-572ffc0b4e20',
            'authenticated',
            'authenticated',
            'reallygoodemail@email.com',
            '$2a$10$OVm64DFu1NXfdXa3cszk7.45/ohzofUFabdUwDpx6u7c.YP5G2ACe',
            current_timestamp,
            current_timestamp,
            current_timestamp,
            '{"provider":"email","providers":["email"]}',
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
    );
