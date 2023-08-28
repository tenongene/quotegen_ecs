// import {
// 	EC2Client,
// 	DescribeInstancesCommand,
// 	TerminateInstancesCommand,
// } from '@aws-sdk/client-ec2';
import { ECSClient, UpdateServiceCommand, DescribeServicesCommand } from '@aws-sdk/client-ecs';
import { fromIni } from '@aws-sdk/credential-provider-ini';
import { fromEnv } from '@aws-sdk/credential-providers';

const client = new ECSClient({
	credentials: fromIni({
		filepath: '../.aws/credentials',
	}),
});

// export const handler = async (req) => {
// 	try {
// 		const instance_filter = {
// 			Filters: [
// 				{
// 					Name: 'tag:Name',
// 					Values: ['quotegen-server'],
// 				},
// 				{
// 					Name: 'instance-state-name',
// 					Values: ['running'],
// 				},
// 			],
// 		};
// 		const getInstances = new DescribeInstancesCommand(instance_filter);
// 		const res = await client.send(getInstances);
// 		const instance_ids = res.Reservations.map((resv) => resv.Instances.map((instance) => instance.InstanceId)).flat();

// 		const instance_list = {
// 			InstanceIds: instance_ids,
// 		};

// 		await client.send(new TerminateInstancesCommand(instance_list));

// 		const response = {
// 			statusCode: 200,
// 			body: JSON.stringify('Quotegen app image successfully updated!'),
// 		};
// 		return response;
// 	} catch (error) {
// 		console.log(error.message);
// 		return {
// 			statusCode: 500,
// 		};
// 	}
// };

const command = new UpdateServiceCommand({
	cluster: 'quotegen_app_cluster',
	service: 'quotegen-svc',
	forceNewDeployment: true,
});

(function () {
	client
		.send(command)
		.then((response) => {
			console.log(response);
			return {
				statusCode: 200,
				body: JSON.stringify('Service redeployed successfully..'),
			};
		})
		.catch((error) => {
			return {
				statusCode: 500,
				message: error.message,
			};
		});
})();
