# Cleanup Instructions

To avoid unexpected cloud charges, follow these steps immediately after testing:

1. **Run the Destroy Script**:
   ```bash
   cd scripts
   bash destroy.sh
   ```

2. **Verify in Console**:
   - Log in to AWS Console.
   - Check EC2 Instances (Ensure 'Terminated').
   - Check Security Groups (Ensure deleted).
   - Check Key Pairs.

3. **Cost Warning**:
   - GPU Instances (g4dn.xlarge) cost approx $0.526/hour (us-east-1).
   - Running this for a month inadvertently can cost ~$380.
   - ALWAYS DESTROY AFTER USE.
