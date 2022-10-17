import React, { useState } from 'react';
import {
	FormColumn,
	FormWrapper,
	FormInput,
	FormSection,
	FormRow,
	FormLabel,
	FormInputRow,
	FormMessage,
	FormButton,
	FormTitle,
	FormSet,
} from './FormStyles';
import { Container } from '../../globalStyles';
// import { useHistory } from 'react-router-dom';

const Form = () => {
	const [createModel, setCreateModel] = useState('');
	const [editModel, setEditModel] = useState('');

	const [createSchedule, setCreateSchedule] = useState('')
	const [editSchedule, setEditSchedule] = useState('')

	const [createSpaces, setCreateSpaces] = useState('')
	const [editSpaces, setEditSpaces] = useState('')

	const [createAgents, setCreateAgents] = useState('')
	const [editAgents, setEditAgents] = useState('')
	const [includeAgentInSpace, setIncludeAgentInSpace] = useState('')


	const [createObservers, setCreateObservers] = useState('')
	const [editObservers, setEditObservers] = useState('')

	const [createScenario, setCreateScenario] = useState('')
	const [editScenario, setEditScenario] = useState('')
	const [initializeAgents, setInitializeAgents] = useState('')
	
	const [error, setError] = useState(null);
	const [success, setSuccess] = useState(null);
	// let history = useHistory();

	const handleSubmit = (e) => {
		e.preventDefault();
		
		setCreateModel('')
		setEditModel('')
		setCreateSchedule('')
		setEditSchedule('')
		setCreateSpaces('')
		setEditSpaces('')
		setCreateAgents('')
		setEditAgents('')
		setIncludeAgentInSpace('')
		setCreateObservers('')
		setEditObservers('')
		setCreateScenario('')
		setEditScenario('')
		setInitializeAgents('')
		setSuccess('Application was submitted!');
	

		/* setTimeout(() => {
			history.push('/21');
		}); */
	};

	const messageVariants = {
		hidden: { y: 30, opacity: 0 },
		animate: { y: 0, opacity: 1, transition: { delay: 0.2, duration: 0.4 } },
	};

	const formModel = [
		{ label: 'Create Model', value: createModel, onChange: (e) => setCreateModel(e.target.value), type: 'text' },
		{ label: 'Edit Model', value: editModel, onChange: (e) => setEditModel(e.target.value), type: 'text' },
		
	];

	const formSchedule = [
		{ label: 'Create Schedule', value: createSchedule, onChange: (e) => setCreateSchedule(e.target.value), type: 'text' },
		{ label: 'Edit Schedule', value: editSchedule, onChange: (e) => setEditSchedule(e.target.value), type: 'text' },
	];

	const formSpaces = [
		{ label: 'Create Spaces', value: createSpaces, onChange: (e) => setCreateSpaces(e.target.value), type: 'text' },
		{ label: 'Edit Spaces', value: editSpaces, onChange: (e) => setEditSpaces(e.target.value), type: 'text' },
		{ label: 'Edit Spaces', value: editSpaces, onChange: (e) => setEditSpaces(e.target.value), type: 'text' },

	];
	const formAgents = [
		{ label: 'Create Agents', value: createAgents, onChange: (e) => setCreateAgents(e.target.value), type: 'text' },
		{ label: 'Edit Agents', value: editAgents, onChange: (e) => setEditAgents(e.target.value), type: 'text' },
		{ label: 'IncludeAgentInSpace', value: includeAgentInSpace, onChange: (e) => setIncludeAgentInSpace(e.target.value), type: 'text' },

	];
	const formObserver = [
		{ label: 'Create Observers', value: createObservers, onChange: (e) => setCreateObservers(e.target.value), type: 'text' },
		{ label: 'Edit Observers', value: editObservers, onChange: (e) => setEditObservers(e.target.value), type: 'text' },
	];
	const formScenario = [
		{ label: 'Create Scenario', value: createScenario, onChange: (e) => setCreateScenario(e.target.value), type: 'text' },
		{ label: 'Edit Scenario', value: editScenario, onChange: (e) => setEditScenario(e.target.value), type: 'text' },
		{ label: 'Initialize Agents', value: initializeAgents, onChange: (e) => setInitializeAgents(e.target.value), type: 'text' },
	]


	return (
		<FormSection>
			<Container>
				<FormRow>
					<FormColumn small>
						<FormTitle>Model</FormTitle>
						<FormWrapper onSubmit={handleSubmit}>
						<FormSet> <legend> Model Definition </legend>
							<br></br>
							{formModel.map((el, index) => (
								<FormInputRow key={index}>
									<FormLabel>{el.label}</FormLabel>
									<FormInput
										placeholder={`Enter here the ${el.label.toLocaleLowerCase()}`}
										value={el.value}
										onChange={el.onChange}
									/>
								</FormInputRow>
						))}			
						</FormSet>

						<FormSet> <legend> Schedule</legend>
							<br></br>	
							{formSchedule.map((el, index) => (
								<FormInputRow key={index}>
									<FormLabel>{el.label}</FormLabel>
									<FormInput
										placeholder={`Enter here the ${el.label.toLocaleLowerCase()}`}
										value={el.value}
										onChange={el.onChange}
									/>
								</FormInputRow>
							))}
						</FormSet>

						<FormSet> <legend> Spaces</legend>
							<br></br>		
							{formSpaces.map((el, index) => (
								<FormInputRow key={index}>
									<FormLabel>{el.label}</FormLabel>
									<FormInput
										placeholder={`Enter here the ${el.label.toLocaleLowerCase()}`}
										value={el.value}
										onChange={el.onChange}
									/>
								</FormInputRow>
							))}			
						</FormSet>

						<FormSet> <legend> Agents</legend>
							<br></br>
							{formAgents.map((el, index) => (
								<FormInputRow key={index}>
									<FormLabel>{el.label}</FormLabel>
									<FormInput
										placeholder={`Enter here the ${el.label.toLocaleLowerCase()}`}
										value={el.value}
										onChange={el.onChange}
									/>
								</FormInputRow>
							))}			
						</FormSet>

						<FormSet> <legend> Observers</legend>
							<br></br>
							{formObserver.map((el, index) => (
								<FormInputRow key={index}>
									<FormLabel>{el.label}</FormLabel>
									<FormInput
										placeholder={`Enter here the ${el.label.toLocaleLowerCase()}`}
										value={el.value}
										onChange={el.onChange}
									/>
								</FormInputRow>
							))}			
						</FormSet>

						<FormSet> <legend> Scenario Definition</legend>
							<br></br>
							{formScenario.map((el, index) => (
								<FormInputRow key={index}>
									<FormLabel>{el.label}</FormLabel>
									<FormInput
										placeholder={`Enter your ${el.label.toLocaleLowerCase()}`}
										value={el.value}
										onChange={el.onChange}
									/>
								</FormInputRow>
							))}			
						</FormSet>

						<FormButton type="submit">Submit</FormButton>
						</FormWrapper>
						
						
						{error && (
							<FormMessage
								variants={messageVariants}
								initial="hidden"
								animate="animate"
								error
							>
								{error}
							</FormMessage>
						)}
						{success && (
							<FormMessage
								variants={messageVariants}
								initial="hidden"
								animate="animate"
								success
							>
								{success}
							</FormMessage>
						)}
					</FormColumn>
				</FormRow>
			</Container>
		</FormSection>
	);
};

export default Form;