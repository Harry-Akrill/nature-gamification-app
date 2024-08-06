<script lang="ts">
	import ManagementTable from '$lib/components/admin/main/questions/ManagementTable.svelte';
	import QuestionField from '$lib/components/admin/main/questions/editfields/QuestionField.svelte';
	import AnswerField from '$lib/components/admin/main/questions/editfields/AnswerField.svelte';
	import { authenticated } from '$lib/stores';

	const getAllQuestions = async () => {
		const response = await fetch('/api/admin/questions');
		const data = await response.json();
		return data.questions;
	};

	const updateQuestion = async (id: number, values: Record<string, string>) => {
		const response = await fetch('/api/admin/questions', {
			method: 'POST',
			body: JSON.stringify({ id, question: values.question, answer: values.answer }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		return data;
	};

	const deleteQuestion = async (id: number) => {
		const response = await fetch('/api/admin/questions', {
			method: 'DELETE',
			body: JSON.stringify({ id }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		return data;
	};
</script>

<div class="relative p-6 h-full w-full">
	<div class="relative card flex bg-base-100 shadow-xl p-6 flex-col h-full w-full overflow-x-auto">
		<ManagementTable
			editFields={[QuestionField, AnswerField]}
			getItemsAction={getAllQuestions}
			editAction={updateQuestion}
			deleteAction={deleteQuestion}
			tableHeaders={['Question', 'Answer', 'Upvotes', 'Downvotes']}
			tableName={'Questions & Answers'}
		/>
	</div>
</div>
