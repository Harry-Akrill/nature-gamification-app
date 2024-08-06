<script>
	let row1LargeText = 'Problem';
	let row1SmallText =
		'There is a high level of stress due to the lines between work and private life become blurred. People feel disconnected with nature as they always find stimulation in indoor activities such as computers, tablets or TVs. The lack of education on why it is important to engage with nature is important due to the health and mental issues are strongly connnected to the lack of connection between human and nature.';
	let row2LargeText = 'Solution';
	let row2SmallText =
		'This app is designed to promote how to spend time in nature through gamification strategies and track time spent in nature. Besides, the app is designed to educate users around the benefits of nature wellbeing.';
</script>

<table>
	<tr>
		<td>
			<div class="large-text">{row1LargeText}</div>
			<div class="small-text">{row1SmallText}</div>
		</td>
	</tr>
	<tr>
		<td>
			<div class="large-text">{row2LargeText}</div>
			<div class="small-text">{row2SmallText}</div>
		</td>
	</tr>
</table>

<style>
	table {
		width: 75%;
		border-collapse: collapse;
		margin-top: 20px;
	}

	td {
		padding: 20px;
		border: 2px solid #ccc;
		text-align: center;
	}

	.large-text {
		font-size: 2.8em;
		font-weight: bold;
	}

	.small-text {
		font-size: 1em;
	}
</style>
