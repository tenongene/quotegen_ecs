import { EC2Client, DescribeInstancesCommand, TerminateInstancesCommand } from '@aws-sdk/client-ec2';
import { fromEnv } from '@aws-sdk/credential-providers';

const client = new EC2Client({
	credentials: fromEnv(),
});

export const handler = async (req) => {
	try {
		const instance_filter = {
			Filters: [
				{
					Name: 'tag:Name',
					Values: ['quotegen-server'],
				},
				{
					Name: 'instance-state-name',
					Values: ['running'],
				},
			],
		};
		const getInstances = new DescribeInstancesCommand(instance_filter);
		const res = await client.send(getInstances);
		const instance_ids = res.Reservations.map((resv) => resv.Instances.map((instance) => instance.InstanceId)).flat();

		const instance_list = {
			InstanceIds: instance_ids,
		};

		await client.send(new TerminateInstancesCommand(instance_list));

		const response = {
			statusCode: 200,
			body: JSON.stringify('Quotegen app image successfully updated!'),
		};
		return response;
	} catch (error) {
		console.log(error.message);
		return {
			statusCode: 500,
		};
	}
};
