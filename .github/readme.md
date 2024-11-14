# TODO

- [ ] Enable frontend tests
- [ ] Integration tests
- [ ] Backend tests
- [ ] e2e

## ONLY ON BILLING PLAN

attest:
  permissions:
    id-token: write
    attestations: write
  runs-on: ubuntu-latest
  needs: build
  steps:
    # Attest reference video
    # https://www.youtube.com/watch?v=zTIHb-9c868
  - name: Attest artifact
    uses: actions/attest-build-provenance@1c608d11d69870c2092266b3f9a6f3abbf17002c # v1.3.2
    with:
      subject-name: ${{ env.REGISTRY_IMAGE }}
      subject-digest: ${{ needs.build.outputs.digest }}
      push-to-registry: true

  - name: Verify OCI image
    env:
      GH_TOKEN: ${{ github.token }}
    run: gh attestation verify oci://${{ env.REGISTRY_IMAGE }}:${{ github.sha }} --owner "$GITHUB_REPOSITORY_OWNER"
