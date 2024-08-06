<script lang="ts">
	import ManagementTable from '$lib/components/admin/main/comments/ManagementTable.svelte';
	import { authenticated } from '$lib/stores';
	import { toast } from 'svelte-sonner';

	// Function to get all comments
	const getAllComments = async () => {
		console.log('Fetching all comments...');
		const response = await fetch('/api/admin/comments');
		const data = await response.json();
		console.log('Comments fetched:', data);
		return data;
	};

	// Function to toggle report status
	const toggleReportStatus = async (id: number) => {
		console.log('Toggling report status for comment with ID:', id);
		const response = await fetch(`/api/admin/comments/${id}/toggle_report_status`, {
			method: 'PATCH',
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		console.log('Change comment status response:', data);

		if (response.ok) {
			toast.success('Comment report status changed successfully!');
			getAllComments();
		} else {
			toast.error('Failed to change comment report status');
		}

		return data;
	};
    // Function to send email notification to user
    const sendEmailNotification = async (commentId: number) => {
            try {
                const response = await fetch(`/api/admin/comments/${commentId}/send_email_notification`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
                const data = await response.json();
                console.log("Email notification response:", data);
            } catch (error) {
                console.error('Error sending email notification:', error);
            }
        };
	// Function to handle comment deletion
	const deleteComment = async (id: number) => {
        await sendEmailNotification(id)
		console.log('Deleting comment with ID:', id);

		const response = await fetch(`/api/admin/comments/${id}`, {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		console.log('Delete response:', data);

		if (response.ok) {
			toast.success('Comment deleted successfully!');
			getAllComments();
		} else {
			toast.error('Failed to delete comment');
		}

        return data;
    };
</script>

<div class="relative p-6 h-full w-full">
	<div class="relative card flex bg-base-100 shadow-xl p-6 flex-col h-full w-full overflow-x-auto">
		<ManagementTable
			getItemsAction={getAllComments}
			deleteAction={deleteComment}
			toggleReportStatusAction={toggleReportStatus}
			tableHeaders={['User Name', 'Poi Name', 'Comment', 'Rating']}
			tableName={'Reported Comments'}
		/>
	</div>
</div>
