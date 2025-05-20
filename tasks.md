### ✅ Reproducibility Task Checklist for **Table 4 – Immutability Results**

> **Goal:** Re-run the artifact’s immutability evaluation (Table 4) and confirm that the numbers reported in the paper
> – **mutable**, **non-transitively immutable**, **dependently immutable**, **transitively immutable** – exactly match the fresh execution results for each call-graph algorithm (**Ad-hoc CHA, CHA, RTA, XTA**).

---

#### 1 • Environment & Container  (Host OS)

* [ ] **Install Docker** (≥ 24.x) on the host machine.
* [ ] **Ensure ≥ 400 GB RAM** is available (as stated in README).
* [ ] `sudo groupadd docker`  and  `sudo usermod -aG docker $USER` (then re-login).
* [ ] **Clone / download** the artifact repository that contains `createContainer.sh` (record commit hash).

#### 2 • Build & Launch the Artifact Container

* [ ] From the repo root, run `sudo ./createContainer.sh` and verify that it finishes without error.
* [ ] Start the image:

  ```bash
  sudo docker run -it unimocgimage
  ```

  (All subsequent commands are executed **inside** the container.)

#### 3 • Execute the Immutability Analyses

* [ ] Run the provided script for all four algorithms:

  ```bash
  /runner/opalImmutability.sh
  ```

  *It writes raw results to* `/evaluation/results/immutability/<Algorithm>/ …`

#### 4 • Aggregate the Results

* [ ] Still inside the container, generate the summary used in the paper:

  ```bash
  python3 /runner/aggregate_opal_immutability.py  | tee /evaluation/results/immutability_results.txt
  ```

  *Keep the `immutability_results.txt` file for verification.*

#### 5 • Extract the Numeric Totals

For each algorithm listed below, write down the four totals echoed by the aggregator (or appearing at the end of each `<Algorithm>` result file):

| Algorithm  | Mutable | Non-Trans. | Depen. | Trans. | ✔ Verified |
| ---------- | ------- | ---------- | ------ | ------ | ---------- |
| Ad-hoc CHA |         |            |        |        | \[ ]       |
| CHA        |         |            |        |        | \[ ]       |
| RTA        |         |            |        |        | \[ ]       |
| XTA        |         |            |        |        | \[ ]       |

*(Fill the empty cells with the freshly produced numbers.)*

#### 6 • Compare with Paper’s Table 4

* [ ] **Reference values** (from the PDF / extracted table):

| Algorithm  | Mutable | Non-Trans. | Depen.          | Trans. |
| ---------- | ------- | ---------- | --------------- | ------ |
| Ad-hoc CHA | 23 195  | 24 296     | 108 ? 46 368 \* | —      |
| CHA        | 23 195  | 25 252     | 20 ? 45 500 \*  | —      |
| RTA        | 23 195  | 7 352      | 316 ? 63 104 \* | —      |
| XTA        | 23 195  | 2 871      | 316 ? 67 585 \* | —      |

*The third column is broken in the extraction; note the full value shown by the aggregator.*

* [ ] For **each algorithm**, tick the ✔ Verified box when the four totals **exactly match** the reference numbers.
* [ ] If any value differs, record the discrepancy (actual vs. expected) in a short markdown table and attach the raw `immutability_results.txt` as evidence.

#### 7 • Document the Reproduction

* [ ] Record: host specs (CPU, RAM), Docker version, image ID, Git commit hash.
* [ ] Archive the following artefacts for the final report:

  * `immutability_results.txt` (aggregated summary)
  * Every raw file under `/evaluation/results/immutability/*`
  * Terminal logs (build, run, aggregation)

#### 8 • Optional Sanity Checks

* [ ] Spot-inspect one raw result file (e.g., `AdHocCHA/result.txt`) to confirm the category totals in its footer equal those gathered by the aggregator.
* [ ] Validate runtime: note total wall-clock time for `/runner/opalImmutability.sh` to aid future replicators.

---

**Completion criterion:** All check-boxes in Sections 1–6 are ticked **and** no discrepancies remain between the paper’s Table 4 numbers and the freshly generated results; or, if differences persist, they are fully documented with raw evidence and environment details.
