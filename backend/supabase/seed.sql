-- comment this code
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