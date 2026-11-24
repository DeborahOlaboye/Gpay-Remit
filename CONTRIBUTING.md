# Contributing to Gpay-Remit

Thank you for your interest in contributing to **Gpay-Remit**! This document provides instructions for setting up your local environment, adhering to code standards, running tests, and submitting pull requests.

---

## 1. Prerequisites

Ensure you have the following toolchains and dependencies installed before starting:

- **Go**: Version `1.25.0` or higher (strictly enforced by CI).
- **Node.js**: Version `20.x` LTS or higher, with `npm` 10+.
- **Rust**: Version `1.75.0` or higher with target `wasm32-unknown-unknown` for Soroban smart contracts.
- **Soroban CLI**: `cargo install soroban-cli`
- **PostgreSQL**: Version `15+` (or via Docker Compose).
- **Redis**: Version `7+` (or via Docker Compose).
- **Docker & Docker Compose**: For containerized local development and services.

---

## 2. Local Environment Setup

### 2.1 Repository Setup

1. Fork the repository on GitHub and clone your fork:
   ```bash
   git clone https://github.com/<your-username>/Gpay-Remit.git
   cd Gpay-Remit
   git remote add upstream https://github.com/parkerwinner/Gpay-Remit.git
   ```

2. Start background services (PostgreSQL & Redis) using Docker Compose:
   ```bash
   docker-compose up -d postgres redis
   ```

### 2.2 Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Copy environment configuration and update secrets as needed:
   ```bash
   cp .env.example .env
   ```
   *(Ensure `JWT_SECRET` is at least 32 characters long).*
3. Download dependencies and run database migrations:
   ```bash
   go mod download
   go run main.go
   ```
   The backend API will be available at `http://localhost:8080`.

### 2.3 Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Copy environment configuration:
   ```bash
   cp .env.example .env
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Start the development server:
   ```bash
   npm start
   ```
   The frontend UI will be available at `http://localhost:3000`.

### 2.4 Contracts Setup

1. Navigate to the contracts directory:
   ```bash
   cd contracts
   ```
2. Build the Soroban contracts:
   ```bash
   cargo build --target wasm32-unknown-unknown --release
   ```

---

## 3. Running Tests

Before submitting changes, make sure all relevant test suites pass:

### 3.1 Backend Tests
```bash
cd backend
go test -race -v ./...
```
To validate OpenAPI specification parity and routing:
```bash
./scripts/validate_openapi.sh
```

### 3.2 Frontend Tests
```bash
cd frontend
npm test -- --watchAll=false
npm run lint
```
To verify frontend TypeScript types against the OpenAPI spec:
```bash
npm run check:types
```

### 3.3 Smart Contract Tests
```bash
cd contracts
cargo test
```

---

## 4. Coding Standards

### 4.1 Go Standards
- Format all Go files with standard formatting: `gofmt -s -w .`
- Ensure all handlers return standardized JSON errors matching the OpenAPI contract.
- Write tests alongside new code (`*_test.go`).
- Avoid global mutable state.

### 4.2 Frontend (JavaScript / TypeScript) Standards
- Maintain strict TypeScript type definitions in `src/types/` generated from the OpenAPI specification (`npm run generate:types`).
- Follow functional React component patterns and hooks.
- Use ESLint: `npm run lint`.

### 4.3 Rust / Soroban Standards
- Format contracts using `make fmt` (runs `cargo fmt --all`); `make fmt-check` runs the same check CI uses.
- Check for linter warnings: `cargo clippy --all-targets`.
- Ensure all public contract functions use explicit authorization (`env.current_contract_address()` or caller `Address::require_auth()`).

### 4.4 Git Commit Conventions
Follow the [Conventional Commits](https://www.conventionalcommits.org/) format:
- `feat: <description>` — New feature
- `fix: <description>` — Bug fix
- `docs: <description>` — Documentation only changes
- `test: <description>` — Adding or refactoring tests
- `chore: <description>` — Build process, dependencies, or auxiliary tool updates

---

## 5. Pull Request Process

1. Create a descriptive branch from latest `main`:
   ```bash
   git checkout -b fix/issue-name
   ```
2. Keep changes focused, minimal, and well-tested.
3. Review your changes with `git diff` before committing.
4. Push to your fork:
   ```bash
   git push origin fix/issue-name
   ```
5. Open a Pull Request targeting `upstream/main`.
6. Fill in the PR template:
   - **Summary**: Concise explanation of what was fixed or added.
   - **Changes**: Bulleted breakdown of code changes.
   - **Issues**: Mention resolved issues using closing keywords (e.g., `Resolves #123`).
   - **Verification**: Explain how you manually reviewed or verified the changes.
7. Ensure all automated CI checks pass.
