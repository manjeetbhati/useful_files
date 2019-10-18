#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>

static struct nf_hook_ops *nfho = NULL;

static unsigned int hfunc(void *priv, struct sk_buff *skb, const struct nf_hook_state *state)
{
    printk(KERN_INFO "Loaded Manjeet's Firewall to Kernel Module\n");
	struct iphdr *iph;
	struct udphdr *udph;
    struct tcphdr *tcph;
	if (!skb)
		return NF_ACCEPT;

	iph = ip_hdr(skb);
    unsigned int src_ip = (unsigned int)iph->saddr;
    unsigned int dest_ip = (unsigned int)iph->daddr;
    printk(KERN_INFO "source ip -- %pI4\n", &dest_ip);
	if (iph->protocol == IPPROTO_UDP) {
		udph = udp_hdr(skb);
        printk(KERN_INFO "traffic for port %d\n", ntohs(udph->dest));
		if (ntohs(udph->dest) == 53) {
			return NF_ACCEPT;
		}
	}
	else if (iph->protocol == IPPROTO_ICMP) {
        return NF_DROP;
    }
	else if (iph->protocol == IPPROTO_TCP) {
		tcph = tcp_hdr(skb);
        printk(KERN_INFO "traffic source port %d\n", ntohs(tcph->source));
		if (ntohs(tcph->dest) == 22) {
            printk(KERN_INFO "traffic for port %d\n", ntohs(tcph->dest));
        }
		return NF_ACCEPT;
	}
	
	return NF_DROP;
}

static int __init LKM_init(void)
{
	nfho = (struct nf_hook_ops*)kcalloc(1, sizeof(struct nf_hook_ops), GFP_KERNEL);
	
	/* Initialize netfilter hook */
	nfho->hook 	= (nf_hookfn*)hfunc;		/* hook function */
	nfho->hooknum 	= NF_INET_POST_ROUTING;		/* out packets */
	nfho->pf 	= PF_INET;			/* IPv4 */
	nfho->priority 	= NF_IP_PRI_FIRST;		/* max hook priority */
	
	nf_register_net_hook(&init_net, nfho);
}

static void __exit LKM_exit(void)
{
	 printk(KERN_INFO "Leaving Manjeet's Firewall from Kernel Module\n");
    nf_unregister_net_hook(&init_net, nfho);
	kfree(nfho);
}

module_init(LKM_init);
module_exit(LKM_exit);
