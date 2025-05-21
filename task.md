# Reproducibility Task Instructions

Follow these steps exactly to reproduce and verify Table 4 from the paper’s artifact.

1. **Clone the repository**

   ```bash
   git clone https://github.com/doehyunbaek/unimocg_artifacts.git
   cd unimocg_artifacts
   ```

2. **Build the Docker image**

   ```bash
   sudo ./createContainer.sh
   ```

3. **Start the container** (detached mode)

   ```bash
   sudo docker run -d --name unimocg-container unimocgimage tail -f /dev/null
   ```

4. **Run the OPAL immutability analysis**

   ```bash
   docker exec unimocg-container /runner/opalImmutability.sh
   ```

5. **Aggregate the results** to a single file

   ```bash
   docker exec unimocg-container python3 /runner/aggregate_opal_immutability.py > /tmp/actual_results.txt
   ```

6. **Copy the aggregated results out** of the container

   ```bash
   docker cp unimocg-container:/tmp/actual_results.txt .
   ```

7. **Parse** `actual_results.txt` to extract, for each algorithm (Ad‑hoc CHA, CHA, RTA, XTA), the four counts:

   * mutable
   * non‑transitively immutable
   * dependently immutable
   * transitively immutable

8. **Compare** the extracted counts against the values listed in `table.md` (path: `{REPO_URL}/table.md`):

   | Algorithm  | Expected Counts (Table 4)        |
   | ---------- | -------------------------------- |
   | Ad‑hoc CHA | `23 195`, `24 296`, `108 46 368` |
   | CHA        | `23 195`, `25 252`, `20 45 500`  |
   | RTA        | `23 195`, `7 352`, `316 63 104`  |
   | XTA        | `23 195`, `2 871`, `316 67 585`  |

   For each algorithm, verify that your extracted sequence exactly matches the expected one.

9. **Document any mismatches or confirm agreement** by creating a `report.md` in the repo root. Include:

   * A table of actual vs. expected counts.
   * Notes on any discrepancies.

10. **Cleanup**

    ```bash
    sudo docker rm -f unimocg-container
    ```
