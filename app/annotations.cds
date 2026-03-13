using CarRentalService from '../srv/service';

annotate CarRentalService.Cars with @(
    UI.HeaderInfo: {
        TypeName: 'Carro',
        TypeNamePlural: 'Carros',
        Title: {
            Value: brand
        },
        Description: {
            Value: model
        }
    },

    UI.LineItem: [
        { Value: brand, Label: 'Marca' },
        { Value: model, Label: 'Modelo' },
        { Value: plate, Label: 'Placa' },
        { Value: dailyRate, Label: 'Diária' },
        { Value: status, Label: 'Status' }
    ],

    UI.Identification: [
        { Value: brand, Label: 'Marca' },
        { Value: model, Label: 'Modelo' },
        { Value: plate, Label: 'Placa' },
        { Value: dailyRate, Label: 'Diária' },
        { Value: status, Label: 'Status' }
    ],

    UI.SelectionFields: [
        brand,
        model,
        plate,
        status
    ]
);

annotate CarRentalService.Clients with @(
    UI.HeaderInfo: {
        TypeName: 'Cliente',
        TypeNamePlural: 'Clientes',
        Title: {
            Value: name
        },
        Description: {
            Value: email
        }
    },

    UI.LineItem: [
        { Value: name, Label: 'Nome' },
        { Value: email, Label: 'Email' },
        { Value: phone, Label: 'Telefone' }
    ],

    UI.Identification: [
        { Value: name, Label: 'Nome' },
        { Value: email, Label: 'Email' },
        { Value: phone, Label: 'Telefone' }
    ],

    UI.SelectionFields: [
        name,
        email,
        phone
    ]
);

annotate CarRentalService.Rentals with @(
UI.HeaderInfo: {
        TypeName: 'Locação',
        TypeNamePlural: 'Locações',
        Title: {
            Value: carModel
        },
        Description: {
            Value: clientName
        }
    },

    UI.LineItem: [
        { Value: carModel, Label: 'Carro' },
        { Value: clientName, Label: 'Cliente' },
        { Value: startDate, Label: 'Início' },
        { Value: endDate, Label: 'Fim' },
        { Value: status, Label: 'Status' }
    ],

    UI.SelectionFields: [
        status,
        startDate,
        endDate
    ],

    UI.FieldGroup #General: {
        Data: [
            { Value: carBrand, Label: 'Montadora' },
            { Value: carModel, Label: 'Modelo' },
            { Value: clientName, Label: 'Cliente' },
            { Value: startDate, Label: 'Início' },
            { Value: endDate, Label: 'Fim' },
            { Value: dailyRate, Label: 'Diária' },
            { Value: totalAmount, Label: 'Total' },
            { Value: status, Label: 'Status' }
        ]
    },

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Detalhes da Locação',
            Target: '@UI.FieldGroup#General'
        }
    ]
);

annotate CarRentalService.Rentals with {
    car @Common.ValueList: {
        CollectionPath: 'Cars',
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',
                LocalDataProperty: car_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'brand'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'model'
            }
        ]
    };

    client @Common.ValueList: {
        CollectionPath: 'Clients',
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',
                LocalDataProperty: client_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            }
        ]
    };
};