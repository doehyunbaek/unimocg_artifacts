# Reproduction Task for *Unimocg: Modular Call-Graph Algorithms for Consistent Handling of Language Features*  

These instructions are written for the **Reproducibility Agent (OpenAI 4.1-nano)** and assume execution inside a fresh **Ubuntu 22.04** container with an interactive shell and sudo rights.

---

## 1. Environment specification

| Requirement | Version / Minimum | Install hint |
|-------------|------------------|--------------|
| OS          | Ubuntu 22.04 LTS | docker image `ubuntu:22.04` is fine |
| Java JDK    | 17 (LTS)         | Temurin / OpenJDK |
| Maven       | ≥ 3.9            | `sudo apt install maven` |
| Git         | ≥ 2.34           | pre-installed in most images |
| Python      | 3.10             | for helper scripts |
| Memory      | 16 GB            | lower may work but is untested |
| Disk        | ≥ 10 GB          | repo + datasets + logs |

Create a working directory you can write to, e.g. `~/unimocg_run/`.

---

## 2. Step-by-step procedure

1. **Clone the artifact repository**
   ```bash
   $ git clone https://github.com/doehyunbaek/unimocg_artfacts.git
   $ cd unimocg_artfacts
   $ git rev-parse HEAD > COMMIT_SHA.txt
```

*Save `COMMIT_SHA.txt`; it records the exact commit you used.*

2. **Familiarise yourself with the project**

   ```bash
   $ ls -1
   ```

   Read quickly through `README.md`, `task.md`, and the `scripts/` or `eval/` folder (if present).
   Jot down the names of any obvious evaluation scripts.

3. **Resolve and cache Java dependencies (no compile yet)**

   ```bash
   $ mvn -q -DskipTests dependency:resolve
   ```

4. **Build the project**

   ```bash
   $ mvn -q -DskipTests package
   ```

   The primary JAR(s) should appear in `target/`.

5. **Run built-in unit tests**

   ```bash
   $ mvn test -q
   ```

   Copy the generated surefire XML logs into `artifacts/logs/`.

6. **Execute the evaluation pipeline**

   *Typical options (pick the one that exists in the repo):*

   * **Provided shell script**

     ```bash
     $ ./scripts/run_evaluation.sh all | tee artifacts/logs/eval.log
     ```
   * **Provided Python driver**

     ```bash
     $ python eval.py --all | tee artifacts/logs/eval.log
     ```
   * **Direct Maven exec**

     ```bash
     $ mvn exec:java -Dexec.mainClass="org.unimocg.Evaluate" -Dexec.args="--all" | tee artifacts/logs/eval.log
     ```

   If none of the above exist, search for a `main` method that looks like an entry point:

   ```bash
   $ grep -R --line-number "public static void main" src/main/java | head
   ```

7. **Collect raw outputs**
   Most runs create CSV/JSON/graph files in a folder such as `results/` or `out/`.
   Move or copy the entire folder to `artifacts/results/`.

8. **Populate results table**
   Open `table.md` (already in the repo) and fill in every empty metrics cell with numbers taken from your run.
   **Do not change column headers or row order.**

9. **Sanity checks**

   *A run counts as “clean” if:*

   * Every benchmark finishes with exit code 0.
   * The number of rows you added equals the number of benchmarks listed.
   * No numeric cell is blank.

10. **Create the reproducibility bundle**

    ```bash
    $ mkdir -p artifacts
    $ tar -czf unimocg_reproduction_$(cat COMMIT_SHA.txt).tar.gz artifacts/ table.md COMMIT_SHA.txt
    ```

11. **Write a 250-word summary**
    Save to `artifacts/summary.txt`. Include:

    * Hardware / software environment
    * Commit SHA
    * Total wall-clock runtime
    * Any deviations from the paper’s reported numbers
    * Whether reproduction was *successful / partially successful / failed*

---

## 3. Completion criteria

| Criterion | Pass condition                                                         |
| --------- | ---------------------------------------------------------------------- |
| Build     | `mvn package` ends with exit 0                                         |
| Tests     | `mvn test` reports **0 failures**                                      |
| Eval      | Evaluation script(s) exit 0                                            |
| Table     | `table.md` fully filled, format unchanged                              |
| Accuracy  | Every reproduced metric differs ≤ 5 % from the paper                   |
| Bundle    | `unimocg_reproduction_$SHA.tar.gz` < 100 MB and contains all artefacts |

---

## 4. Interaction policy (tips for 4.1-nano)

* Keep each answer ≤ 8 sentences.
* After **every** shell command, say in one line what happened (“Build succeeded”, “4 tests failed”, …).
* If you see a stack trace: include it **all** in your reply, then ask for guidance.
* When in doubt, ask instead of guessing.
