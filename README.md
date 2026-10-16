<p align="center">
  <img src="images/banner.svg" alt="Edvanta — Learn Your Way banner" width="100%">
</p>

<h1 align="center">Learning Management System — Edvanta</h1>

<p align="center">
A modern full-stack <strong>Learning Management System (LMS)</strong> for online learning, course management,
assessments, progress tracking, and administration — with secure JWT authentication and
role-based access for <strong>Learners, Instructors, and Administrators</strong>.
</p>

> **Complete documentation:** [`documents/output/Edvanta-Complete-Documentation.pdf`](documents/output/Edvanta-Complete-Documentation.pdf)
> (96-page evidence-based suite: BRD, PRD, functional / non-functional / technical requirements,
> system & software architecture, HLD, LLD, API, auth, security, testing, deployment, roadmap, glossary.)
> Sources live in [`documents/latex/`](documents/latex/) with diagrams in [`documents/latex/diagrams/`](documents/latex/diagrams/).

<p align="center">
  <img src="https://img.shields.io/badge/frontend-React_18_%2B_Vite_6_%2B_AntD_5-blue" alt="Stack">
  <img src="https://img.shields.io/badge/backend-Spring_Boot_3.3.4_%2B_Java_21-green" alt="Backend">
  <img src="https://img.shields.io/badge/database-MySQL_8_%2B_H2_tests-orange" alt="Database">
  <img src="https://img.shields.io/badge/auth-Spring_Security_%2B_JWT-red" alt="Auth">
</p>

---

<h2 align="center">Table of Contents</h2>
- [Overview](#overview)
- [Screenshots](#screenshots)
- [Objectives](#objectives)
- [User Roles](#user-roles)
- [Core Features](#core-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Authentication Flow](#authentication-flow)
- [Authorization](#authorization)
- [Database Design](#database-design)
- [API Documentation](#api-documentation)
- [Learning Lifecycle](#learning-lifecycle)
- [Quiz & Assessment Flow](#quiz-assessment-flow)
- [Certificates](#certificates)
- [Testing](#testing)
- [Docker](#docker)
- [Deployment](#deployment)
- [Development Guidelines](#development-guidelines)
- [Security Considerations](#security-considerations)
- [Roadmap](#roadmap)
- [Known Issues & Technical Debt](#known-issues-technical-debt)
- [Contributing](#contributing)
- [License](#license)
- [Project](#project)
- [Documentation](#documentation)

---

<h2 align="center">Overview</h2>

The Learning Management System (**product brand: Edvanta** — see `frontend/index.html` and
`frontend/src/components/Footer.jsx`) is a web-based platform connecting learners, instructors,
and administrators through a centralized learning environment.

The platform supports the complete learning lifecycle:

```text
User Registration
        ↓
Course Discovery
        ↓
Course Enrollment
        ↓
Learning & Progress Tracking
        ↓
Assessments
        ↓
Performance Evaluation
        ↓
Course Completion
        ↓
Certificate
```

<p align="center"><img src="documents/latex/diagrams/learning-lifecycle.png" alt="Learning lifecycle"></p>

Each user type gets the features relevant to their responsibilities, enforced **server-side**
by Spring Security — frontend route guards are UX-only (see `CONTRACT.md` §13).

---

<h2 align="center">Screenshots</h2>

> Full application tour in journey order: landing → auth → learner → instructor.
> Branding assets: [`images/banner.svg`](images/banner.svg) (README banner),
> [`images/logo.png`](images/logo.png) (app icon), [`images/logotype.png`](images/logotype.png) (wordmark).

<h3 align="center">Landing — Home</h3>

**1. Hero — "Empower your future with structured learning and verified credentials"**

![Home hero](images/01-home-hero.jpeg)

**2. Hero (scrolled) with platform intro peeking below**

![Home hero scrolled](images/02-home-hero-scrolled.jpeg)

**3. Platform features — curriculum, assessments, certificates**

![Home features](images/03-home-features.jpeg)

**4. How it works — Learn / Assess / Certify**

![Home how it works](images/04-home-how-it-works.jpeg)

**5. Featured courses catalogue grid**

![Home featured courses](images/05-home-featured-courses.jpeg)

**6. Footer call-to-action + site footer**

![Home footer CTA](images/06-home-footer-cta.jpeg)

<h3 align="center">Authentication</h3>

**7. Sign in — "Welcome Back" / "Log in to Edvanta"**

![Sign in](images/07-auth-signin.jpeg)

<h3 align="center">Learner workspace</h3>

**8. Learner dashboard — enrolled / in-progress / completed / certificates stats**

![Learner dashboard](images/08-learner-dashboard.jpeg)

**9. Learner "Your courses" library with live progress**

![Learner my courses](images/09-learner-my-courses.jpeg)

**10. Course classroom — video player, curriculum checklist, 100% progress**

![Course classroom](images/10-learner-classroom.jpeg)

**11. Course certificate modal with credential ID + print/save**

![Course certificate](images/11-learner-certificate.jpeg)

**12. Learner profile & settings**

![Learner profile settings](images/12-learner-profile-settings.jpeg)

<h3 align="center">Instructor studio</h3>

**13. Instructor hub — course management & curriculum directory**

![Instructor hub](images/13-instructor-hub.jpeg)

**14. Manage course content — lessons table**

![Manage lessons](images/14-instructor-manage-lessons.jpeg)

**15. Manage course content — assessments / quizzes table**

![Manage assessments](images/15-instructor-manage-assessments.jpeg)

**16. "Add Lesson" dialog — title, objectives, duration, video URL, notes**

![Add lesson modal](images/16-instructor-add-lesson-modal.jpeg)

**17. "Create Assessment" dialog — questions, options, correct answer, points**

![Create assessment](images/17-instructor-create-assessment.jpeg)

<h3 align="center">Catalogue & account</h3>

**18. Explore course catalogue — search + category filter (12 courses)**

![Catalogue explore](images/18-catalogue-explore.jpeg)

**19. Instructor profile & settings**

![Instructor profile settings](images/19-instructor-profile-settings.jpeg)

---

<h2 align="center">Objectives</h2>

- Provide a centralized platform for online learning.
- Let users discover and enroll in courses.
- Provide structured course content and learning materials.
- Track learner progress (per-lesson → per-course aggregation).
- Conduct online assessments and quizzes with **server-side scoring**.
- Record and display learner performance.
- Enable communication and discussion around courses.
- Give instructors tools to manage courses, lessons, quizzes, and question banks.
- Give administrators centralized user / course / category / assessment management.
- Generate certificates after verified course completion.
- Maintain secure authentication and role-based access control.

---

<h2 align="center">User Roles</h2>

The system has three primary roles, stored in `users.role` (`database/schema.sql`, default `LEARNER`)
and enforced by `backend/.../config/SecurityConfig.java` plus route guards in
`frontend/src/routes/AppRoutes.jsx` / `ProtectedRoute.jsx`.

<h3 align="center">Learner</h3>

- Register and log in.
- Browse, search, and view course information.
- Enroll in courses (duplicate enrollment rejected with `409`).
- Access lessons and learning materials (`/courses/:courseId/learn`).
- Track learning progress (dashboard + progress bar).
- Complete assessments and quizzes (`/quizzes/:id`).
- View assessment results and learning history.
- Participate in course discussions; submit course feedback.
- Download course-completion certificates.

<h3 align="center">Instructor</h3>

- Create, edit, publish, and delete own courses.
- Add and organize lessons; upload/link learning resources.
- Create quizzes and manage assessment questions.
- Monitor learner progress and review performance in own courses.
- Interact with learners through course discussions.

<h3 align="center">Administrator</h3>

- Manage users, instructors, courses, categories.
- Manage assessments and question banks.
- Monitor platform activity; review learner performance.
- Manage system-level configuration; control access through role permissions.
- Access `/admin`, `/admin/users`, `/admin/categories` dashboards.

---

<h2 align="center">Core Features</h2>

<h3 align="center">Authentication &amp; Authorization</h3>

- User registration / login / logout (`POST /api/v1/auth/*`).
- BCrypt password hashing; stateless JWT (JJWT 0.12.6, 24h expiry).
- Axios interceptor attaches `Authorization: Bearer <token>` (`frontend/src/api/client.js`).
- Protected routes + role guards (`ProtectedRoute.jsx`); server is the authority.

<h3 align="center">Course Management</h3>

- Course creation, editing, publishing, deletion, categorization.
- Course descriptions, lessons (`order_index`, `duration_minutes`), learning resources.
- Course enrollment / unenrollment with unique `(user_id, course_id)` constraint.

<h3 align="center">Learning Module</h3>

- Lesson navigation and video/content player (`LessonPlayer.jsx`, `LearningPage.jsx`).
- Lesson completion → persisted progress → dashboard reflection.
- Built-in **coding practice**: course-attached problems with embedded OneCompiler editor
  (`frontend/src/pages/practice/`, iframe + `postMessage` starter-code injection).

<h3 align="center">Progress Tracking</h3>

- Course completion percentage, completed lessons, watch time, assessment completion.
- Backend source of truth: `ProgressService` + `progress` table → `CourseProgressResponse`.

```text
Course Progress
────────────────────────────
████████████████░░░░  80%

Completed Lessons: 8 / 10
Assessment: Completed
Status: In Progress
```

<h3 align="center">Assessments &amp; Quizzes</h3>

- Multiple-choice questions, question banks, course-specific quizzes.
- Quiz attempts with **server-side validation and scoring** (`QuizService`) —
  the frontend is never authoritative for scores.
- Score calculation, result storage, performance history.

<h3 align="center">Discussions &amp; Feedback</h3>

- Course discussions with replies (`DiscussionList.jsx`, `DiscussionItem.jsx`).
- Course feedback and ratings (`FeedbackForm.jsx`).

<h3 align="center">Certificates</h3>

- Completion verification by `CertificateService` (enrollment + progress + quiz outcome).
- Learner identification, course information, completion date, grade, download (`CertificateCard.jsx`).

---

<h2 align="center">System Architecture</h2>

Classical **three-tier client–server** architecture. Every interaction is a synchronous
HTTP request/response cycle — no message broker, cache, search engine, or background worker.

<p align="center"><img src="documents/latex/diagrams/system-architecture.png" alt="System architecture"></p>

```text
                   ┌───────────────────┐
                   │      Client       │
                   │   React Frontend  │
                   └─────────┬─────────┘
                             │
                             │ HTTP / REST API
                             ▼
                   ┌───────────────────┐
                   │      Backend      │
                   │   Spring Boot     │
                   ├───────────────────┤
                   │ Controllers       │
                   │ Services          │
                   │ Repositories      │
                   │ Security          │
                   └─────────┬─────────┘
                             │
                             │ JPA / Hibernate
                             ▼
                   ┌───────────────────┐
                   │     Database      │
                   │      MySQL        │
                   └───────────────────┘
```

<h3 align="center">Frontend</h3>

<p align="center"><img src="documents/latex/diagrams/frontend-architecture.png" alt="Frontend architecture"></p>

Responsible for UI, routing (19 routes), form handling, auth state (`AuthContext.jsx`),
API communication (`frontend/src/api/` — 13 modules), course player, dashboards,
and progress visualization.

<h3 align="center">Backend</h3>

<p align="center"><img src="documents/latex/diagrams/backend-layers.png" alt="Backend layers"></p>

Responsible for business logic, authentication, authorization, REST APIs (47 endpoints,
11 controllers), validation, data processing, and database interaction.
Layering: **Controller → Service → Repository → Database**
(`backend/src/main/java/com/example/lms/`).

<h3 align="center">Database</h3>

Responsible for users, courses, enrollments, lessons, progress, quizzes, questions,
attempts, results, discussions, feedback, and certificates — 13 tables in
`database/schema.sql`.

---

<h2 align="center">Technology Stack</h2>

Versions taken from `backend/pom.xml` and `frontend/package.json`.

| Layer | Technology |
|---|---|
| Frontend | React 18.3.1 |
| Build tool | Vite 6.0.1 (dev server on `:3000`, proxies `/api`) |
| Routing | React Router 6.28.0 (`frontend/src/routes/AppRoutes.jsx`, 19 routes) |
| HTTP client | Axios 1.7.9 (`frontend/src/api/client.js` — JWT header, envelope unwrap) |
| Styling | Tailwind CSS 3.4.16 |
| UI Components | Ant Design 5.22.2 + `@ant-design/icons` 5.5.2 |
| Backend | Spring Boot 3.3.4 |
| Language | Java 21 (`<java.version>`, `backend/Dockerfile`) |
| API | REST, versioned under `/api/v1` |
| Authentication | Spring Security + JWT (JJWT 0.12.6, BCrypt) |
| ORM | Spring Data JPA / Hibernate (13 repositories, `ddl-auto: update`) |
| Database | MySQL 8 (runtime), H2 (tests) — `database/schema.sql` |
| Build Tool | Maven (`backend/pom.xml`, `mvnw` / `mvnw.cmd`) |
| API Documentation | springdoc-openapi 2.6.0 → `/v3/api-docs`, `/swagger-ui.html` |
| Testing | Spring Test + Vitest 2.1.8 (Testing Library, jsdom) |
| Containerisation | Docker (backend `backend/Dockerfile`, multi-stage JDK/JRE 21) |
| Version Control | Git & GitHub (branches `main`, `frontend/*`, `backend/*` per `CONTRACT.md`) |

---

<h2 align="center">Project Structure</h2>

Verified against the repository (Spring layering per `CONTRACT.md` §7, React layout per §8):

```text
FSJP_LMS/
│
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/lms/
│   │   │   │   ├── config/        # SecurityConfig, OpenApiConfig, DataInitializer
│   │   │   │   ├── controller/    # 11 controllers (Auth, User, Course, Enrollment,
│   │   │   │   │                 # Lesson, Progress, Quiz, Discussion, Feedback,
│   │   │   │   │                 # Certificate, Category)
│   │   │   │   ├── dto/           # request/* + response/* (API contract)
│   │   │   │   ├── entity/        # 13 JPA entities (User, Course, Lesson, Quiz, …)
│   │   │   │   ├── exception/     # error handling
│   │   │   │   ├── repository/    # 13 Spring Data repositories
│   │   │   │   ├── security/      # JWT filter / principal
│   │   │   │   ├── service/       # 11 services (business rules, transactions)
│   │   │   │   └── LmsApplication.java
│   │   │   └── resources/         # application.yml
│   │   └── test/                  # 10 classes, 22 tests incl. LmsIntegrationTest
│   ├── pom.xml
│   ├── mvnw / mvnw.cmd
│   └── Dockerfile
│
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── api/           # 13 modules: auth, user, course, enrollment, lesson,
│   │   │                 # progress, quiz, discussion, feedback, certificate,
│   │   │                 # category + client.js + index.js
│   │   ├── assets/
│   │   ├── components/    # AppShell, Navbar, Sidebar, CourseCard/List/Details,
│   │   │                 # EnrollmentButton, LessonPlayer, ProgressBar, QuizCard,
│   │   │                 # QuizPage/Result, Discussion*, FeedbackForm,
│   │   │                 # CertificateCard, Learner/Instructor/Admin dashboards,
│   │   │                 # + common/, ui/, practice/
│   │   ├── context/       # AuthContext.jsx (localStorage session)
│   │   ├── data/          # static practice dataset (isolated, by design)
│   │   ├── hooks/
│   │   ├── pages/         # Home, Login, Register, CourseCatalog, CourseDetail,
│   │   │                 # Learning, QuizTaking, Profile, NotFound + practice/
│   │   ├── routes/        # AppRoutes.jsx (19 routes), ProtectedRoute.jsx
│   │   ├── test/          # 8 files, 39 tests (Vitest)
│   │   ├── utils/         # constants (ROLES), helpers
│   │   ├── App.jsx        # antd theme (black primary, 4px radius, 40px controls)
│   │   └── main.jsx
│   ├── index.html         # "Edvanta -- Learn Your Way"
│   ├── package.json
│   ├── vite.config.js     # :3000 + /api proxy
│   └── tailwind.config.js # design tokens
│
├── database/
│   ├── schema.sql         # 13 tables (users → certificates)
│   ├── seed.sql
│   └── dummy.sql
│
├── documents/
│   ├── latex/             # full documentation sources (39 sections)
│   │   ├── diagrams/      # 9 .mmd sources + 9 .png renders
│   │   └── sections/
│   └── output/
│       └── FSJP_LMS-Complete-Documentation.pdf  # generated complete document
│
├── CONTRACT.md            # two-workstream engineering contract (Jay/Ali)
├── README.md
├── .env.example
└── .gitignore
```

---

<h2 align="center">Prerequisites</h2>

- Java 21
- Node.js 18+ and npm
- MySQL 8+
- Git
- Optional: Docker

---

<h2 align="center">Installation</h2>

<h3 align="center">1. Clone the repository</h3>

```bash
git clone <repository-url>
cd FSJP_LMS
```

<h3 align="center">2. Configure the Database</h3>

```sql
CREATE DATABASE lms;
```

```bash
mysql -u root -p lms < database/schema.sql
# optional sample data:
mysql -u root -p lms < database/seed.sql
```

<h3 align="center">3. Configure Backend</h3>

Copy and edit environment from `.env.example`:

```text
PORT=8080
DB_URL=jdbc:mysql://localhost:3306/lms?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
DB_USERNAME=root
DB_PASSWORD=root
JWT_SECRET=<generate-a-strong-secret>
JWT_EXPIRATION=86400000
```

> Never commit real secrets. Production must inject them via environment / secret manager
> and rotate the example `JWT_SECRET`.

<h3 align="center">4. Start the Backend</h3>

```bash
cd backend
./mvnw spring-boot:run        # Windows: mvnw.cmd spring-boot:run
```

Backend at `http://localhost:8080`. Swagger UI at
`http://localhost:8080/swagger-ui/index.html`, OpenAPI JSON at `/v3/api-docs`.

<h3 align="center">5. Start the Frontend</h3>

```bash
cd frontend
npm install
npm start                     # vite on http://localhost:3000
```

Set `VITE_API_BASE_URL=http://localhost:8080` (see `.env.example`).

---

<h2 align="center">Configuration</h2>

| Variable | Owner | Purpose |
|---|---|---|
| `PORT` | Backend | API listen port (`8080`) |
| `DB_URL` / `DB_USERNAME` / `DB_PASSWORD` | Backend | MySQL datasource |
| `JWT_SECRET` / `JWT_EXPIRATION` | Backend | Token signing key + TTL (ms) |
| `VITE_API_BASE_URL` | Frontend | Single base URL used by all `src/api/*` modules |

---

<h2 align="center">Authentication Flow</h2>

Stateless JWT: register/login → signed token → `localStorage` → `Authorization: Bearer`
header per request → Spring Security validation → role enforcement.

<p align="center"><img src="documents/latex/diagrams/authentication-flow.png" alt="Authentication flow"></p>

```text
User
 │
 ▼
Login
 │
 ▼
Backend Authentication
 │
 ▼
JWT Generated
 │
 ▼
Frontend Stores Session Token
 │
 ▼
Authenticated API Request
 │
 ▼
JWT Validation
 │
 ▼
Role Authorization
 │
 ▼
Protected Resource
```

Logout is client-side token removal plus `POST /api/v1/auth/logout`.
No refresh rotation, revocation list, password recovery, or email verification in v1.0.

---

<h2 align="center">Authorization</h2>

Server-enforced; frontend guards mirror it for UX only.

| Feature | Learner | Instructor | Admin |
|---|:---:|:---:|:---:|
| Browse / view courses | ✓ | ✓ | ✓ |
| Enroll in courses | ✓ | — | ✓ |
| Access lessons / track own progress | ✓ | ✓ (own) | ✓ |
| Take quiz / view own results | ✓ | — | ✓ |
| Create / edit / delete own course | — | ✓ | ✓ |
| Manage lessons / questions / quizzes | — | ✓ | ✓ |
| View learner performance | — | ✓ (own) | ✓ |
| Participate in discussions | ✓ | ✓ | ✓ |
| Submit feedback | ✓ | — | — |
| Manage users / instructors / all courses | — | — | ✓ |
| Access admin dashboard | — | — | ✓ |

---

<h2 align="center">Database Design</h2>

13 tables with foreign keys, unique constraints, and indexes (`database/schema.sql`):
`users`, `categories`, `courses`, `lessons`, `enrollments` (unique `user_id+course_id`),
`progress`, `quizzes`, `questions`, `quiz_attempts`, `quiz_attempt_answers`,
`discussions`, `feedback`, `certificates`.

<p align="center"><img src="documents/latex/diagrams/database-er.png" alt="Database ER"></p>

```text
User
 │
 ├───────────────┐
 │               │
 ▼               ▼
Enrollment      Assessment
 │               │
 ▼               ▼
Course          Result
 │
 ├── Lesson
 │
 ├── Question
 │
 ├── Discussion
 │
 └── Feedback
```

> Note: runtime schema is managed by Hibernate `ddl-auto: update`; hand-written
> `schema.sql` can drift — versioned migrations (Flyway/Liquibase) are recommended
> before multi-instance deployment.

---

<h2 align="center">API Documentation</h2>

Base path `/api/v1`, JSON, envelope `ApiResponse` / `ErrorResponse`
(`backend/.../dto/response/`). Interactive docs when backend runs:
`http://localhost:8080/swagger-ui/index.html`.

| Group | Endpoints |
|---|---|
| Auth | `POST /api/v1/auth/register`, `POST /api/v1/auth/login`, `POST /api/v1/auth/logout` |
| Users | `GET /api/v1/users`, `GET /api/v1/users/{id}`, `PUT /api/v1/users/{id}` |
| Courses | `GET /api/v1/courses`, `GET /api/v1/courses/{id}`, `POST /api/v1/courses`, `PUT /api/v1/courses/{id}`, `DELETE /api/v1/courses/{id}` |
| Enrollment | `POST /api/v1/courses/{courseId}/enroll`, `DELETE /api/v1/courses/{courseId}/enroll`, `GET /api/v1/users/{userId}/enrollments` |
| Lessons | `GET /api/v1/courses/{courseId}/lessons`, `GET /api/v1/lessons/{lessonId}`, `POST /api/v1/courses/{courseId}/lessons`, `PUT /api/v1/lessons/{lessonId}`, `DELETE /api/v1/lessons/{lessonId}` |
| Progress | `GET /api/v1/courses/{courseId}/progress`, `POST /api/v1/lessons/{lessonId}/progress`, `PATCH /api/v1/lessons/{lessonId}/progress` |
| Quizzes | `GET /api/v1/courses/{courseId}/quizzes`, `GET /api/v1/quizzes/{quizId}`, `POST /api/v1/quizzes/{quizId}/attempts`, `GET /api/v1/quizzes/{quizId}/results` + instructor CRUD |
| Discussions | `GET/POST /api/v1/courses/{courseId}/discussions`, replies, delete |
| Feedback | `GET/POST /api/v1/courses/{courseId}/feedback`, `PUT /api/v1/feedback/{feedbackId}` |
| Certificates | `GET/POST /api/v1/courses/{courseId}/certificate` |
| Categories | CRUD under `/api/v1/categories` |

Error codes: `VALIDATION_ERROR` 400, `UNAUTHORIZED` 401, `FORBIDDEN` 403,
`RESOURCE_NOT_FOUND` 404, `RESOURCE_CONFLICT` 409, `INVALID_OPERATION` 422,
`INTERNAL_SERVER_ERROR` 500.

---

<h2 align="center">Learning Lifecycle</h2>

Register → login → browse (`/courses`) → detail (`/courses/:id`) → enroll →
learn (`/courses/:courseId/learn`) → progress persisted → quiz → certificate.
Covered end-to-end by `LmsIntegrationTest`. Practice pages (`/practice`,
`/courses/:courseId/practice`) use the isolated static dataset in `frontend/src/data/`.

<h2 align="center">Quiz &amp; Assessment Flow</h2>

<p align="center"><img src="documents/latex/diagrams/quiz-submission-sequence.png" alt="Quiz submission sequence"></p>

```text
Open Quiz
  ↓
Answer Questions
  ↓
Submit
  ↓
Backend Validates
  ↓
Score Calculated
  ↓
Result Stored
  ↓
Frontend Displays Result
```

<h2 align="center">Certificates</h2>

<p align="center"><img src="documents/latex/diagrams/certificate-eligibility.png" alt="Certificate eligibility"></p>

Eligibility is verified server-side by `CertificateService`
(enrollment + progress + quiz outcome) before `GET/POST /api/v1/courses/{courseId}/certificate`
issues the row rendered by `CertificateCard.jsx`.

---

<h2 align="center">Testing</h2>

```bash
cd backend
./mvnw test          # 22 tests / 10 classes (H2), incl. LmsIntegrationTest end-to-end

cd frontend
npm test              # vitest run — 39 tests / 8 files (Testing Library + jsdom)
```

Layers: unit → integration → API → frontend component → end-to-end
(register/login, enrollment, progress, assessment, certificate).

---

<h2 align="center">Docker</h2>

Backend multi-stage image (`backend/Dockerfile`: Maven + JDK 21 build → JRE 21 runtime,
`EXPOSE 8080`). No frontend Dockerfile or compose file in v1.0.

```text
┌───────────────────────┐
│   Frontend (Vite)     │
│   static dist/ host   │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│   Backend Container   │
│     Spring Boot       │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│   MySQL Container     │
│      Database         │
└───────────────────────┘
```

---

<h2 align="center">Deployment</h2>

<p align="center"><img src="documents/latex/diagrams/deployment.png" alt="Deployment"></p>

Verified development topology: MySQL `:3306` + `./mvnw spring-boot:run` on `:8080` +
Vite on `:3000`. Production needs HTTPS, rotated secrets, managed MySQL with backups,
versioned migrations, CORS allow-list, structured logging, monitoring, and rollback plan.
No CI/CD (`.github/`) exists — builds/tests are manual (see `documents/.../cicd`).

---

<h2 align="center">Development Guidelines</h2>

New features follow:

```text
Database / Entity → Repository → Service → Controller
      → API Service (frontend/src/api) → Component → Route/Page → Tests
```

- Controllers handle HTTP; services own business logic; repositories own persistence.
- Pages are screens; `components/` are reusable UI; `hooks/` hold reusable logic;
  `context/` holds shared state.
- Respect workstream ownership: `frontend/**` (Jay) vs `backend/**` + `database/**` (Ali);
  shared files (`README.md`, `CONTRACT.md`, `.env.example`, API/schema contracts)
  need cross-review. Full rules in `CONTRACT.md`.

---

<h2 align="center">Security Considerations</h2>

Implemented: BCrypt hashing, signed expiring JWTs, server-side RBAC, Bean Validation,
JPA-bound queries, non-leaking error envelopes, env-based secrets.

Must-haves before production: rotate `JWT_SECRET`, guard/remove `DataInitializer` demo
seeds, add rate limiting + lockout, HTTPS + security headers, CORS review, audit logging,
secret manager, and migration-based schema control. Sensitive values
(`JWT_SECRET`, `DB_PASSWORD`, `ADMIN_PASSWORD`) must never be committed.

---

<h2 align="center">Roadmap</h2>

<h3 align="center">Phase 1 — Core LMS (implemented)</h3>

- [x] Authentication (JWT) + user roles
- [x] Course catalogue, details, enrollment (duplicate-safe)
- [x] Learning content + lesson navigation
- [x] Progress tracking (persisted, aggregated)
- [x] Assessments with server-side scoring + results
- [x] Discussions + feedback (already implemented)
- [x] Certificates with eligibility verification
- [x] Coding practice pages (static dataset, by design)

<h3 align="center">Phase 2 — Engagement</h3>

- [ ] Notifications
- [ ] Learning analytics + improved learner dashboard
- [ ] Feedback/ratings polish

<h3 align="center">Phase 3 — Instructor Platform</h3>

- [ ] Course authoring UX + lesson management polish
- [ ] Assessment authoring + learner performance analytics

<h3 align="center">Phase 4 — Advanced Platform</h3>

- [ ] Certificate verification
- [ ] Search/filtering, recommendations
- [ ] Password recovery, email notifications
- [ ] CI/CD, production monitoring, scalable deployment

Explicitly out of v1.0 unless agreed (`CONTRACT.md` §5.2): payments, live classes,
mobile app, AI tutoring/recommendations, SSO, multi-tenancy, offline-first.

---

<h2 align="center">Known Issues &amp; Technical Debt</h2>

Summary (full register in the PDF §§ Known Issues / Technical Debt):

- Certificate grade `DISTINCTION` vs column default `PASS` (cosmetic).
- Quiz percentage denominator counts only submitted questions.
- README roadmap previously drifted vs implemented discussions/feedback (reconciled here).
- Unguarded seed users; `ddl-auto: update` without versioned migrations; no CI gates;
  JWT without revocation; unbounded list endpoints.

---

<h2 align="center">Contributing</h2>

```text
Create Branch → Implement → Write Tests → Run Tests
     → Review → Create Pull Request → Code Review → Merge
```

- Branch from workstream: `frontend/...` or `backend/...`; never develop on `main`.
- PRs include summary, changes, files, tests, expected behavior, known issues.
- Follow conventional commits (`feat(frontend): …`, `fix(backend): …`).
- Run `./mvnw test` and `npm test` before every PR; keep shared-contract changes reviewed.

---

<h2 align="center">License</h2>

This project is licensed under the **MIT License** (no root `LICENSE` file is currently
checked in — adding one is recommended).

---

<h2 align="center">Project</h2>

**Project:** Learning Management System (Edvanta) · **Type:** Full-Stack Web Application ·
**Architecture:** Client–Server (three-tier) · **Frontend:** React 18 + Vite 6 ·
**Backend:** Spring Boot 3.3.4 + Java 21 · **Database:** MySQL 8 · **Auth:** JWT · **API:** REST `/api/v1`

<h2 align="center">Documentation</h2>

Full suite: [`documents/output/Edvanta-Complete-Documentation.pdf`](documents/output/Edvanta-Complete-Documentation.pdf) —
Project Overview · Business / Product / Functional / Non-Functional / Technical Requirements ·
System / Software Architecture · HLD / LLD · Database Design · API · Authentication /
Authorization · User & Data Flows · UI/UX · Design System · Security · Performance /
Scalability · Testing · Deployment · CI/CD · Integrations · Configuration · SEO/AEO/GEO ·
Known Issues · Technical Debt · Roadmap · Development & Contribution Guides · Glossary.
Engineering source of truth: [`CONTRACT.md`](CONTRACT.md).
