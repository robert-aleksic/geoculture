var wms_layers = [];


        var lyr_OpenStreetMap_0 = new ol.layer.Tile({
            'title': 'OpenStreetMap',
            'opacity': 1.000000,
            
            
            source: new ol.source.XYZ({
            attributions: ' ',
                url: 'http://a.tile.openstreetmap.org/{z}/{x}/{y}.png'
            })
        });
var format_slike_1 = new ol.format.GeoJSON();
var features_slike_1 = format_slike_1.readFeatures(json_slike_1, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_slike_1 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_slike_1.addFeatures(features_slike_1);
var lyr_slike_1 = new ol.layer.Vector({
                declutter: false,
                source:jsonSource_slike_1, 
                style: style_slike_1,
                popuplayertitle: 'slike',
                interactive: true,
                title: '<img src="styles/legend/slike_1.png" /> slike'
            });

lyr_OpenStreetMap_0.setVisible(true);lyr_slike_1.setVisible(true);
var layersList = [lyr_OpenStreetMap_0,lyr_slike_1];
lyr_slike_1.set('fieldAliases', {'redni broj': 'redni broj', 'URL': 'URL', 'thumb': 'thumb', 'koordinate': 'koordinate', 'y': 'y', 'x': 'x', 'id. Broj': 'id. Broj', 'naziv djela': 'naziv djela', 'ime autora': 'ime autora', 'prezime autora': 'prezime autora', 'godina nastanka': 'godina nastanka', 'tehnika': 'tehnika', 'format': 'format', 'vlasnik': 'vlasnik', 'link vlasnik': 'link vlasnik', 'glavni narativ uz djelo )pojavljije se kao prvi pasus)': 'glavni narativ uz djelo )pojavljije se kao prvi pasus)', 'sekundarni narativ uz djelo, slijedi nakon prvog, služi obično da se povežu pojedine tačke': 'sekundarni narativ uz djelo, slijedi nakon prvog, služi obično da se povežu pojedine tačke', 'narativ za koji se veže. Ako ih ima više razdvojiti ih sa tačka zarez, npr: Miunović Milo;Boka kotorska; ovo se pojavljuje nakon teksta o jedinici': 'narativ za koji se veže. Ako ih ima više razdvojiti ih sa tačka zarez, npr: Miunović Milo;Boka kotorska; ovo se pojavljuje nakon teksta o jedinici', 'način pojavljivanja prilikom pretrage? Ovome je posvećena velia pažnja u ovoj probnoj aplikacij': 'način pojavljivanja prilikom pretrage? Ovome je posvećena velia pažnja u ovoj probnoj aplikacij', 'kategorija': 'kategorija', 'komentar uz link, tj. Informacija na što upućuje pošto se uvijek ne zaključuje iz linka. U U mapu ovo ide zajedno': 'komentar uz link, tj. Informacija na što upućuje pošto se uvijek ne zaključuje iz linka. U U mapu ovo ide zajedno', 'Column4': 'Column4', });
lyr_slike_1.set('fieldImages', {'redni broj': '', 'URL': '', 'thumb': '', 'koordinate': '', 'y': '', 'x': '', 'id. Broj': '', 'naziv djela': '', 'ime autora': '', 'prezime autora': '', 'godina nastanka': '', 'tehnika': '', 'format': '', 'vlasnik': '', 'link vlasnik': '', 'glavni narativ uz djelo )pojavljije se kao prvi pasus)': '', 'sekundarni narativ uz djelo, slijedi nakon prvog, služi obično da se povežu pojedine tačke': '', 'narativ za koji se veže. Ako ih ima više razdvojiti ih sa tačka zarez, npr: Miunović Milo;Boka kotorska; ovo se pojavljuje nakon teksta o jedinici': '', 'način pojavljivanja prilikom pretrage? Ovome je posvećena velia pažnja u ovoj probnoj aplikacij': '', 'kategorija': '', 'komentar uz link, tj. Informacija na što upućuje pošto se uvijek ne zaključuje iz linka. U U mapu ovo ide zajedno': '', 'Column4': '', });
lyr_slike_1.set('fieldLabels', {'redni broj': 'no label', 'URL': 'no label', 'thumb': 'no label', 'koordinate': 'no label', 'y': 'no label', 'x': 'no label', 'id. Broj': 'no label', 'naziv djela': 'no label', 'ime autora': 'no label', 'prezime autora': 'no label', 'godina nastanka': 'no label', 'tehnika': 'no label', 'format': 'no label', 'vlasnik': 'no label', 'link vlasnik': 'no label', 'glavni narativ uz djelo )pojavljije se kao prvi pasus)': 'no label', 'sekundarni narativ uz djelo, slijedi nakon prvog, služi obično da se povežu pojedine tačke': 'no label', 'narativ za koji se veže. Ako ih ima više razdvojiti ih sa tačka zarez, npr: Miunović Milo;Boka kotorska; ovo se pojavljuje nakon teksta o jedinici': 'no label', 'način pojavljivanja prilikom pretrage? Ovome je posvećena velia pažnja u ovoj probnoj aplikacij': 'no label', 'kategorija': 'no label', 'komentar uz link, tj. Informacija na što upućuje pošto se uvijek ne zaključuje iz linka. U U mapu ovo ide zajedno': 'no label', 'Column4': 'no label', });
lyr_slike_1.on('precompose', function(evt) {
    evt.context.globalCompositeOperation = 'normal';
});