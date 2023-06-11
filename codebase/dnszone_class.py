import ansible_runner

result = ansible_runner.run(private_data_dir='runner', playbook='update_dns.yml')

print("Playbook executed with status: ", result.status)
print("Stats of the run: ", result.stats)