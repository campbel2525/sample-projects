import debugpy

debugpy.listen(("0.0.0.0", 9003))
print("waiting ...")
debugpy.wait_for_client()
