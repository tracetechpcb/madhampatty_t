import 'assets/css/App.css';

import React from 'react';
import ReactDOM from 'react-dom';

import AuthLayout from 'layouts/auth';
import MainLayout from 'layouts/main';
import {
  HashRouter,
  Redirect,
  Route,
  Switch,
} from 'react-router-dom';
import theme from 'theme/theme';

import { ChakraProvider } from '@chakra-ui/react';
import { ThemeEditorProvider } from '@hypertheme-editor/chakra-ui';

ReactDOM.render(
	<ChakraProvider theme={theme}>
		<React.StrictMode>
			<ThemeEditorProvider>
				<HashRouter>
					<Switch>
						<Route path={`/auth`} component={AuthLayout} />
						<Route path={`/main`} component={MainLayout} />
						<Redirect from='/' to='/auth' />
					</Switch>
				</HashRouter>
			</ThemeEditorProvider>
		</React.StrictMode>
	</ChakraProvider>,
	document.getElementById('root')
);
