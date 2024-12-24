CREATE TYPE payment_methods AS ENUM ('CARD', 'PAYPAL');
CREATE TYPE order_status AS ENUM ('PENDING', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED');


-- Roles Table
CREATE TABLE roles (
    id UUID PRIMARY KEY,
    code VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    username VARCHAR UNIQUE NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    addresses TEXT[],
    role_id UUID REFERENCES roles(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Carts Table
CREATE TABLE carts (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Categories Table
CREATE TABLE categories (
    id UUID PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL
);
-- Products Table
CREATE TABLE products (
    id UUID PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL NOT NULL,
    category_id UUID REFERENCES categories(id) NOT NULL,
    stock INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP
);
-- Cart Details Table
CREATE TABLE cart_details (
    id UUID PRIMARY KEY,
    cart_id UUID REFERENCES carts(id) NOT NULL,
    product_id UUID REFERENCES products(id) NOT NULL,
    quantity INT NOT NULL
);


-- Product Images Table
CREATE TABLE product_images (
    id UUID PRIMARY KEY,
    product_id UUID REFERENCES products(id) NOT NULL,
    url VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- Favorite Products Table
CREATE TABLE favorites (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) NOT NULL,
    product_id UUID REFERENCES products(id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Orders Table
CREATE TABLE orders (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) NOT NULL,
    status order_status NOT NULL,
    total DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP
);

-- Order Details Table
CREATE TABLE order_items (
    id UUID PRIMARY KEY,
    order_id UUID REFERENCES orders(id) NOT NULL,
    product_id UUID REFERENCES products(id) NOT NULL,
    cart_id UUID REFERENCES carts(id) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL NOT NULL
);
-- Token Types Table
CREATE TABLE token_types (
    id UUID PRIMARY KEY,
    token_name VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Tokens Table
CREATE TABLE tokens (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) NOT NULL,
    token_type UUID REFERENCES token_types(id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- Payments Table
CREATE TABLE payments (
    id UUID PRIMARY KEY,
    order_id UUID REFERENCES orders(id) NOT NULL,
    payment_status payment_methods NOT NULL,
    stripe_payment_intent VARCHAR NOT NULL,
    stripe_payment_id VARCHAR NOT NULL,
    stripe_api_version VARCHAR NOT NULL,
    total_payment JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Add Foreign Keys
ALTER TABLE carts ADD CONSTRAINT fk_carts_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE cart_details ADD CONSTRAINT fk_cart_details_cart_id FOREIGN KEY (cart_id) REFERENCES carts(id);
ALTER TABLE cart_details ADD CONSTRAINT fk_cart_details_product_id FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE products ADD CONSTRAINT fk_products_category_id FOREIGN KEY (category_id) REFERENCES categories(id);
ALTER TABLE product_images ADD CONSTRAINT fk_product_images_product_id FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE favorites ADD CONSTRAINT fk_favorites_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE favorites ADD CONSTRAINT fk_favorites_product_id FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_product_id FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_cart_id FOREIGN KEY (cart_id) REFERENCES carts(id);
ALTER TABLE payments ADD CONSTRAINT fk_payments_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE tokens ADD CONSTRAINT fk_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE tokens ADD CONSTRAINT fk_tokens_token_type FOREIGN KEY (token_type) REFERENCES token_types(id);
