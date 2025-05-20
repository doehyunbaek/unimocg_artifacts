Here’s a runnable checklist your Reproducibility Agents can follow to verify that Table 4 in the paper matches the actual outputs of the artifact:

* [ ] **Clone the artifact repository**

  ```bash
  git clone https://github.com/doehyunbaek/unimocg_artifacts.git
  cd unimocg_artifacts
  ```
* [ ] **Build the Docker container**

  ```bash
  sudo ./createContainer.sh
  ```
* [ ] **Start the container (detached, so you can exec into it later)**

  ```bash
  sudo docker run -d --name unimocg-container unimocgimage sleep infinity
  ```
* [ ] **Inside the container, run the OPAL immutability analysis**

  ```bash
  docker exec unimocg-container /runner/opalImmutability.sh
  ```
* [ ] **Aggregate the immutability results to a file**

  ```bash
  docker exec unimocg-container python3 /runner/aggregate_opal_immutability.py > /tmp/immutability_results_actual.txt
  ```
* [ ] **Copy the aggregated results out of the container**

  ```bash
  docker cp unimocg-container:/tmp/immutability_results_actual.txt .
  ```
* [ ] **Extract from `immutability_results_actual.txt` the four counts for each algorithm**

  * mutable
  * non-transitively immutable
  * dependently immutable
  * transitively immutable
* [ ] **Compare against the extracted Table 4 values**

  | Algorithm  | Extracted Table 4 (as shown)     |
  | ---------- | -------------------------------- |
  | Ad-hoc CHA | `23 195`, `24 296`, `108 46 368` |
  | CHA        | `23 195`, `25 252`, `20 45 500`  |
  | RTA        | `23 195`, `7 352`, `316 63 104`  |
  | XTA        | `23 195`, `2 871`, `316 67 585`  |

  For each line, verify that the sequence of numbers printed in the summary exactly matches the corresponding row above.
* [ ] **Document any mismatches** (or confirm perfect agreement) and file a short report to close out the reproducibility check.
