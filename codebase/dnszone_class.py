import dns.query
import dns.tsigkeyring
import dns.update

class DNSUpdater:
    def __init__(self, zone, key_name, secret_key, dns_server):
        self.zone = zone
        self.dns_server = dns_server
        self.keyring = dns.tsigkeyring.from_text({key_name: secret_key})

    def add_record(self, name, record_type, record_data, ttl=300):
        update = dns.update.Update(self.zone, keyring=self.keyring)
        update.add(name, ttl, record_type, record_data)
        response = dns.query.tcp(update, self.dns_server)
        return response.rcode() == dns.rcode.NOERROR

    def delete_record(self, name, record_type):
        update = dns.update.Update(self.zone, keyring=self.keyring)
        update.delete(name, record_type)
        response = dns.query.tcp(update, self.dns_server)
        return response.rcode() == dns.rcode.NOERROR


if __name__ == '__main__':

    dns_updater = DNSUpdater('yourzone.example.com', 'key-name', 'your secret key', 'DNS_SERVER_IP_ADDRESS')

    if dns_updater.add_record('newhost', 'A', '192.0.2.1'):
        print('Record added successfully')
    else:
        print('Failed to add record')

    if dns_updater.delete_record('oldhost', 'A'):
        print('Record deleted successfully')
    else:
        print('Failed to delete record')

