<h4 align="center">Tests for gh-workflow project</h4>

https://github.com/andry81-devops/gh-workflow

##

## Usage

### Local

1. Download gh-workflow:

   ```console
   git clone https://github.com/andry81-devops/gh-workflow
   ```

2. Open Linux or Cygwin console, for example, in `tests/manual/bash/cache/*` directory.

> [!NOTE]
> Base distribution of Linux Ubuntu 20.x/24.x and Cygwin 3.x contains https://github.com/kislyuk/yq implementation.  
> Github Actions distribution of Linux Ubuntu 20.x/24.x contains https://github.com/mikefarah/yq/ implementation.

3. Optionally copy into `tools` directory an `yq.exe` executable to use a particular `yq` implementation.

4. Set workflow root variables:

   ```console
   GH_WORKFLOW_ROOT=$(realpath PATH-TO-GH-WORKFLOW-ROOT)
   ```

5. Run a test script:

   ```console
   ./test.sh
   ```

6. The `/tmp` directory would contain the intermediate files to compare between each other.
