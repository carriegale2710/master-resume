# **Name**

## **Junior Full-Stack Developer | React, TypeScript, Node.js, Java, Spring Boot, SQL, AWS**

${RESUME_LOCATION} | ${RESUME_PHONE} | ${RESUME_EMAIL} | ${RESUME_LINKS}

Career-transition junior full-stack developer with hands-on experience delivering NestJS/MySQL and Next.js features in an Agile team, and building deployed applications with React, TypeScript, Java/Spring Boot and SQL. Combines end-to-end engineering delivery with UX and accessibility expertise to build practical, user-centred web products.

## **Education**

- ### **Queensland University of Technology — Graduate Certificate of IT Remote | Feb 2026 – Jul 2026**

  Computer Science major; GPA: 6.5

- ### **The University of Sydney — Bachelor of Arts Sydney, NSW | Mar 2020 – Dec 2023**

  Design & Digital Cultures; WAM: 63

## **Certifications & Training**

- ### **\_nology — Pathway to Tech: Software Engineering Training Program Sydney, NSW | Mar 2025 – Jul 2025**

  Selected in the top 12 of 1,000+ applicants; learnt full-stack skills in HTML/CSS, Javascript, React, TypeScript, Java, Spring Boot, SQL, and AWS testing and deployment within 3-4 months through project-based evaluation.

## **Relevant Work Experience**

### **\_nology — Software Engineer Intern Sydney, NSW | Jun 2025 – Aug 2025**

- Delivered a Student Tracker notes feature so coaching staff could securely record, review and manage observations about student performance throughout a course.
- Built the NestJS and MySQL backend, including controllers, services, entities, DTOs, modules and three REST API endpoints, turning a need for centralised feedback into a working product feature.
- Modelled the SQL data and implemented role-based authorisation for Admin, Coach and Student users, so sensitive student information was available only to the right people.
- Created a database migration and seeded 50 representative records, giving the team repeatable test data and more reliable local validation.
- Added Next.js functionality, Playwright coverage and Postman API tests to validate the full workflow from the UI through to the database.
- Used GitHub Issues and an Agile Kanban project board to receive sprint tickets, track progress and create pull requests with the development team, keeping feature delivery visible and aligned with priorities.
- Paired with a junior developer for peer programming on assigned tickets and participated in daily stand-ups with senior developers, surfacing blockers early and supporting timely completion of sprint work.
- Strengthened validation in the Student Notes API DTOs after pull-request feedback, handling incomplete and invalid input more consistently before it reached the database.

## **Projects**

### [**Employee Creator | Full-Stack Web Application**](https://github.com/carriegale2710/employee-creator)

#### _Secure employee and contract-management platform that brings employee record administration into one application._

- Built a React and TypeScript frontend with a Java/Spring Boot REST API and MySQL database, allowing users to register employees, manage contract details and retrieve records in the browser.
- Improved record-retrieval responsiveness by refining concurrent query handling and structuring the MySQL data layer, making it easier to work with multiple employee records.
- Deployed the application to AWS EC2 with HTTPS, a custom domain, Log4j logging and health checks, supporting secure access and earlier visibility of issues.
- Moved the demo environment from AWS EC2 to Render and PostgreSQL, keeping the application publicly available while avoiding unnecessary cloud spend.
- Added more than 40 automated Jest, JUnit, Mockito and REST Assured tests, plus GitHub Actions checks on every pull request, catching issues earlier and reducing regression risk before release.
- Used AI to maintain changelog documentation and explore implementation options, then reviewed, selected and adapted the approach that best fit the codebase and requirements.
- Managed personal project tickets, sprint priorities and delivery documentation in Trello using Agile sprint templates, creating a structured workflow for planning, implementation, testing and follow-up work.

### [**Indigenous Library Portal | Full-Stack Web Application for Indigenous Collections**](https://github.com/carriegale2710/indigenous-library)

#### _Secure collections portal that protects culturally sensitive material and gives authorised curators and collection owners an auditable process for reviewing access._

- Built custom Flask accounts, login/logout, session management and role-based access control for around 30 collection items, restricting access to sensitive records and management functions to authorised users.
- Replaced static content with live MySQL queries and role-aware request, assessment, comment and review workflows, bringing collection-access reviews into one application.
- Designed a database-driven decision model for Pending, Open, Restricted and Culturally Sensitive statuses, recording reviewers, dates and decision history to provide an audit trail beyond a basic public/private setting.
- Simplified the information architecture with Bootstrap and Jinja templates, removing redundant and out-of-scope content so non-technical users could find relevant actions and information more easily.
- Coordinated a five-person team over two weeks by standardising Flask routes with Blueprints, resolving inconsistent data naming and adding automated tests, reducing integration risk before delivery.
- Deployed the portal on AWS and later migrated the live demo to Render with HTTPS, a custom domain and GitHub Actions CI/CD to refresh database data and run tests, maintaining public access while reducing manual release checks and hosting overhead.

### [**GAIA 2.0 | Perplexity-Based Agent Prompting System**](https://github.com/carriegale2710/gaia-2.0)

#### _Improved an open-source AI-agent framework by reorganising memory, planning, permissions and reusable skills across projects._

- Separated memory, planning and permission-instruction modules, reducing context-memory calls and estimating a 60% reduction in AI token costs and 80% reduction in prompt instruction inconsistencies.
- Evaluated architectural trade-offs for storing persistent agent skills, memory and context across four to five Perplexity sandbox workspaces for implicit retrieval or saving directly to GitHub repository agent folders requiring manual user activation, deciding on a flexible, agent-agnostic hybrid approach.
- Implemented a hybrid persistent agent memory framework including a master GitHub skills repository, agent subfolders within project repositories for project-only specific skills and plans, and one to two Perplexity Spaces for sharing broadly useful helper skills between all projects (eg. ‘/research’ and ‘/pr-review’ skills).
- Limited each run to the instructions and skills relevant to the task, improving output relevance and preserving context for project-specific work while retaining reusable organisational knowledge.

### **BeautyUnlocked (formerly ABeaute) | Disability-Inclusive Beauty E-Commerce Platform**

_Early-stage e-commerce marketplace concept designed to reduce online beauty-shopping barriers for people with mobility, vision and sensory disabilities. Work in progress._

- Independently designed and built a waitlist landing page using JavaScript, HTML/CSS, Figma, Vercel and Supabase, with Resend or Tally supporting email-confirmation automation.
- Consulted with an occupational-therapist co-founder with direct client experience to review early assumptions and identify mobility, vision and sensory access considerations, translating stakeholder feedback into accessibility priorities for the MVP.
- Applied accessibility-first frontend practices including semantic HTML, labelled forms, keyboard-operable interactions, visible focus states, readable typography and colour-contrast checks with tools such as Lighthouse to make the landing-page experience more usable without relying on a third-party accessibility overlay.
- Designed a custom accessibility-preferences concept for text size, spacing, font choice and colour-vision support, while prioritising accessible defaults and predictable interaction patterns rather than treating personalisation as a substitute for accessible design.
- Used Claude/Codex and Google Stitch as assistive tools while retaining responsibility for review, testing and changes before merging; translated concepts into Figma mock-ups, a design system and a lightweight launch-ready website within three to four weeks.
- Presented the technical and financial case for a React/Next.js and Supabase MVP to non-technical co-founders, proposing an accessibility roadmap based on accessible components and progressive WCAG conformance without expensive premium-plugin subscriptions.

## **Other Work Experience**

### **Outlier / Scale AI — AI Prompt Designer & QA Tester (Freelance) Remote | Mar 2025 – Present**

- Evaluated AI-generated React, HTML and CSS frontend code and UI output against requirements, using structured prompts, rubrics and reviewer feedback to identify usability, implementation and code-generation issues before release.
- Created a rubric template and final checklist in response to reviewer feedback, making it easier to distinguish acceptable outputs from work that needed revision and improving evaluation consistency.
- Wrote multi-step, golden-example prompts and detailed evaluation feedback, making testing more repeatable across model scenarios.
- Applied frontend, UX and design-system judgement when assessing generated outputs against requirements, strengthening QA, specification review, edge-case identification and technical communication.
- Improved the quality of later submissions by refining the rubric template and checklist after reviewer feedback, making them more consistent, clear and concise.
- Completed 50–100 in-depth, multi-prompt evaluation tasks lasting two to six hours across four to six projects, contributing to pre-release model improvements in reasoning, data science/data manipulation, audio/music and research-intensive domains.
- Currently evaluate AI-generated UX/UI and frontend code for Figma, Google Stitch and v0 on a specialist model-training project, after being scouted for design and frontend expertise.
- Compared LLM text, image and audio outputs, then wrote structured justifications and improvement feedback for QA team leads.
- Author multi-step, golden-example-based prompts to surface failure modes and edge cases, using prompt-engineering methods to strengthen evaluation rigour.

### **Self-Employed — UX/UI Designer (Freelance) Sydney, NSW | May 2023 – Dec 2024**

- Delivered UX/UI audits and website-redesign recommendations for e-commerce clients, translating business goals, user feedback and technical findings into prioritised improvement plans.
- Used website analytics, Lighthouse and WCAG audits to identify checkout usability, performance and accessibility issues in marketplace sites; proposed revised flows and improved accessibility scores by an average of 15–30% across client projects.
- Explained design rationale and technical concepts, including accessibility, performance and user-flow friction, in plain language for non-technical stakeholders.
- Managed projects from discovery through delivery by scoping work, prioritising tasks, incorporating feedback and iterating designs to reduce rework; revised branding, confirmed direction, then built a working landing page and social-media marketing strategies.
- Built end-to-end experience in requirements gathering, analytical problem-solving, accessibility testing, stakeholder management and delivery ownership.

### **Gapmash — User Experience (UX) Design Intern Sydney, NSW | Oct 2023 – Nov 2024**

- Worked in an Agile, cross-functional team to prioritise and iterate product improvements, redesigning Figma screens within an established design system.
- Communicated design decisions, clarified requirements and incorporated team feedback; updated prototype designs after product-manager feedback to make them gender-inclusive and consistent with brand assets and the design system.
- Turned usability-testing findings into onboarding changes projected to increase task-completion rates by 15%.
- Analysed user-survey feedback and proposed a personalised quiz feature projected to improve Day-1 retention by 15%.
- Used research evidence to explain trade-offs and prioritise changes with the strongest expected impact on users and the product.

## **Leadership & Activities**

### **Remarkable Tech — Launcher: Preaccelerator Program Sydney, NSW | Mar 2025 – May 2025**

- Selected as a founder-team member for a competitive disability-tech pre-accelerator and refined the business model and go-to-market strategy with industry mentors, strengthening the venture’s path to market validation.
- Prioritised the simplest viable solution for testing demand, balancing delivery speed, accessibility needs and future scalability rather than overbuilding before validation.
- Facilitated feedback cycles from founder coaches to convert accessibility needs and business goals into clear technical specifications, aligning technical and non-technical collaborators.
- Built and tested early MVP prototypes with real users, identifying usability and accessibility issues before further development investment.

### **Startmate — Student Fellowship Sydney, NSW | Dec 2024 \- Dec 2024**

- Selected as a top-six finalist from 60 teams in the fellowship’s VC competition, reflecting the team’s ability to communicate the user problem, product rationale and key trade-offs.
- Collaborated in a two-week sprint from problem definition to prototype and investor-style pitch, aligning user research, product scope and commercial narrative under tight time constraints.
- Turned ambiguous user research and early product findings into prioritised MVP requirements, focusing limited resources on the highest-value problems to test first.
- Led UX/UI design sprints for an accessibility-focused beauty e-commerce concept, turning the needs of people with mobility, vision and sensory disabilities into an interactive Figma prototype designed to reduce online-shopping barriers.

### **MIXSOC (USyd Society) — Founder & President Sydney, NSW | Jun 2021 – Jun 2022**

- Grew membership from zero to more than 100 in the first year through targeted social campaigns, marketing assets, founding-member recruitment and community events.
- Led and delegated work across a 17–20-person executive team to deliver more than 20 annual events for 300+ attendees, contributing to a University of Sydney Best New Society nomination.
- Secured increased University funding by demonstrating member demand and event activity, enabling higher-quality events at a larger scale.
- Coordinated joint campus-festival events with other societies, aligning teams, schedules, promotion and event requirements to create larger shared student experiences.
- Built small-business partnerships to support events and member benefits, developing outreach, relationship management, negotiation and mutual-value communication skills.
- Shifted delivery online during COVID-19, maintaining member engagement as conditions changed.

### **Sydney Abroad (USyd) — Student Peer Mentor Sydney, NSW | Mar 2020 – Jun 2020**

- Mentored three incoming international exchange students through their cross-cultural transition, strengthening communication and supportive collaboration in diverse teams.

### **Korea University / Rikkyo University — Exchange Programs South Korea / Japan | Jun 2018 – Feb 2019**

- Studied intermediate-to-advanced Korean and beginner Japanese through intensive language classes while living overseas, building independence, adaptability and communication skills for internationally distributed teams.
