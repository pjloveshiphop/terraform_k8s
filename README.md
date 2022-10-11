# terraform_k8s

![alt text](https://github.com/pjloveshiphop/terraform_k8s/blob/main/app_diagram.png?raw=true)













### [문제 정의]
 1. Kubernetes 도입결정으로 인한 AWS EKS 인프라 구축 
 2. k8s를 이용한 간단한 api 제공 application 작성



### [첫번째 task 문제 해결 과정]
1.AWS EKS 구축을 위한 필요 resource 파악\
	- VPC, subnet, route table, internet gateway etc..\
	- VPC 관련 resource들은 이미 구축되어 있다고 했으므로 생략\
	- IAM Role for EKS cluster, policies, security group, EKS cluster\
	- IAM Role for node group, polices

2.필요한 resource 생성을 위한 reference lookup \
 	- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster \
	-https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group \
	-https://github.com/hashicorp/terraform-provider-aws/tree/main/examples

3.실제코딩
	-단, 공식 terraform aws_eks_node_group 문서에는 manage node 구축 예시만 나와잇으므로, terrafrom 에서 제공하는 self managed node module 을 사용하기로 결정함
	

### [두번째 task 문제 해결 과정]
1.간단한 api를 제공하는 app을 만들어야 하므로 python flask framework를 이용해 random uuid를 return하는 app.py 구현\
2.해당 app을 Dockerfile을 활용하여 image build\
3.deployment, service 구성을 위한 yaml파일 작성 및 reference lookup \
	-https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-deployment-tutorial-example-yaml.html \
	-https://kubernetes.io/docs/concepts/workloads/controllers/deployment/ \
	-https://kubernetes.io/docs/concepts/services-networking/service/ \
	-https://matthewpalmer.net/kubernetes-app-developer/articles/service-kubernetes-example-tutorial.html 

4.추가적으로 외부사에게 노출되어야 하므로 ingress 구성 yaml파일 작성 및 reference lookup\
5.minikube를 활용해 간단한 테스트 \
	- https://kubernetes.io/docs/concepts/services-networking/ingress/ \
6.app 도식화
