# Project Genesis: A Process Diary for the `ProjectBank` Data Pipeline

### Introduction
This document chronicles the iterative design and development of the `Professional branch` data generation pipeline. The goal is to provide insight into my working style, showcasing not just the final product, but the critical thinking, problem-solving, and collaborative process required to build a professional-grade data project from the ground up. The following are curated milestones from my working session with Google Gemini 2.5 Pro, acting as my AI project manager.

---

### Milestone 1: From Broad Ideas to a Unified Foundation
**My Thought Process:** *(My initial goal was to create several separate projects. However, I realized that building a single, high-quality, and reusable healthcare dataset would be a more powerful and efficient foundation for my entire portfolio. I decided to pivot and focus on creating one exceptional asset first.)*

**Key Chat Excerpt:**
> **Me:** "I am thinking the dataset could lean toward heavily on healthcare insurance since this the filed where I gained my data analyst experience from. The dataset will be recycled for different projects that I have listed... Also I have some sql code on my previous academic sql project... Maybe we could salvage from there?"

[cite_start]**Outcome:** This decision focused the entire effort on creating a single, robust, and realistic healthcare dataset that would serve as the source of truth for all subsequent analytics projects[cite: 1].

---

### Milestone 2: Deepening the Data Model with Business Logic
**My Thought Process:** *(A simple dataset isn't enough. To make the record linkage task realistic, the data couldn't be perfect. I began to question the initial assumptions, like the `household_id`, to intentionally introduce the kind of 'noisy' data I've encountered in professional settings.)*

**Key Chat Excerpt:**
> **Me:** "Having a valid household id assigned will make the job too easy and doesn't look realistic at all. If a company already has a valid hsehold id assigned, the dedup will never be needed as the db design and the record keeping are doing a good job?"

**Outcome:** This critical insight led to the implementation of imperfect features. The `household_id` was redesigned to be a "mostly helpful, but sometimes misleading" clue, making the `splink` record linkage project a much more challenging and impressive task.

---

### Milestone 3: Introducing Advanced Data Architecture
**My Thought Process:** *(To showcase skills beyond basic analysis, I decided to incorporate professional data engineering concepts. Standard flat tables don't preserve history, which is critical for insurance analytics. I proposed building the `Members` table as a proper Slowly Changing Dimension (SCD) Type 2.)*

**Key Chat Excerpt:**
> **Me:** "Also, we could just add rec_start_date and rec_end_date to manage the timeflow, which could show I have knowledge on SCD type 2 (Data architect/Enigeneer)."

**Outcome:** This decision was a major turning point. It transformed the project from generating a simple snapshot to creating a historically accurate, enterprise-grade data model. This directly led to the two-stage **OLTP (source) to OLAP (analytics)** project plan.

---

### Milestone 4: From Script to Professional Software
**My Thought Process:** *(As the script's complexity grew, I knew it needed to follow professional software standards. A single script with hard-coded values is hard to maintain. I proposed separating the configuration from the logic by using a `config.yaml` file, and then refactoring the code itself into a modular package.)*

**Key Chat Excerpt:**
> **Me:** "hum.... actually if we are creating that much dict. let's change to config.yaml instead?... The scripts could run as it is... while we could define all dtype mapping over there... This could save the repetition on some columns and more elegant way to approach this topic."

**Outcome:** This refactoring resulted in a clean, maintainable, and professional data generation pipeline. The final product is not just a script, but a well-engineered package that separates configuration from logic.

---

### Milestone 5: Debugging and Final Polish
**My Thought Process:** *(Even with a solid design, execution always presents challenges. I encountered several errors during testing, from Python scope issues to data type mismatches with the database. I systematically worked through each one, refining the code to make it more robust and error-proof.)*

**Key Chat Excerpt:**
> **Me:** `pandas._libs.tslibs.np_datetime.OutOfBoundsDatetime: Out of bounds nanosecond timestamp: 9999-12-31...`
> **Me (later):** "How about we change the effective date to null and therefore, could minimise the change in the script? And in a way this is true since there's no end date for that record yet."

**Outcome:** This iterative debugging process led to a final script that is not only functional but also resilient, with professional-grade logging, error handling, and robust data conversion logic.

---

### Conclusion
This process diary demonstrates a commitment to building not just a functional product, but a professional and well-architected one. The project evolved significantly from its initial concept, driven by a continuous process of questioning assumptions, incorporating advanced technical principles, and adhering to industry best practices.